// Pure Dart (no Flutter imports): this file is exercised on its own with
// `dart run --enable-vm-service` — see the doc comment on [startHangWatchdog].
import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:isolate';

import 'package:vm_service/vm_service.dart' as vms;
import 'package:vm_service/vm_service_io.dart';

/// Live progress trace + hang watchdog for the integration tests.
///
/// The test reporter only prints a test's output once the test has *finished*,
/// so a test that hangs (the doc tour did, three times in one week, right
/// after its build with 30 minutes of silence until the job timeout) leaves
/// nothing behind to say where it got stuck. [traceStep] therefore writes
/// straight to the process's stderr, which `flutter test -d linux` forwards
/// live (that is how mpv's own messages reach the CI log), and
/// [startHangWatchdog] runs a second isolate that keeps checking on the main
/// one: it receives a heartbeat from a timer in the main isolate every few
/// seconds (carrying the last traced step and whatever [extraState] adds) and
/// when either stops moving it prints the main isolate's Dart stack through
/// the VM service. A separate isolate because a main isolate stuck in
/// synchronous code (or a blocking native call) cannot run its own timers;
/// the VM service can still interrupt it at a safepoint.
///
/// To try it by hand (the main isolate spins for 30 s, the watchdog reports
/// after [heartbeatStall]):
///
///     dart --packages=.dart_tool/package_config.json --enable-vm-service=0 \
///       integration_test/support/hang_watchdog.dart
///
/// No heartbeat for [heartbeatStall]: the main isolate is not running its
/// event loop at all (synchronous loop, blocking native call, deadlock). No
/// new step for [stepStall]: the test awaits something that never completes
/// (a frame the engine never delivers, a request, a stream). While still
/// stuck the report repeats every [repeatEvery], so the log shows whether the
/// stack moves at all.
Future<void> startHangWatchdog({
  Map<String, Object?> Function()? extraState,
  Duration heartbeatStall = const Duration(seconds: 45),
  Duration stepStall = const Duration(minutes: 3),
  Duration repeatEvery = const Duration(minutes: 2),
  Duration heartbeatEvery = const Duration(seconds: 5),
}) async {
  if (_watchdogPort != null) return;
  _extraState = extraState;
  final port = ReceivePort();
  String? wsUri;
  String? mainIsolateId;
  try {
    final info = await developer.Service.getInfo();
    final uri = info.serverUri;
    if (uri != null) {
      wsUri = uri
          .replace(
              scheme: uri.scheme == 'https' ? 'wss' : 'ws',
              path: '${uri.path}ws')
          .toString();
    }
    mainIsolateId = developer.Service.getIsolateId(Isolate.current);
  } catch (e) {
    stderr.writeln('[e2e ${_clock()}] watchdog: no VM service ($e); '
        'it will report progress only, no stacks');
  }
  if (wsUri == null || mainIsolateId == null) {
    stderr.writeln('[e2e ${_clock()}] watchdog: VM service not available '
        '(uri=$wsUri isolate=$mainIsolateId); progress only, no stacks');
  }
  _watchdogIsolate = await Isolate.spawn(
    _watchdogMain,
    _WatchdogConfig(
      reply: port.sendPort,
      wsUri: wsUri,
      mainIsolateId: mainIsolateId,
      heartbeatStall: heartbeatStall,
      stepStall: stepStall,
      repeatEvery: repeatEvery,
    ),
    debugName: 'e2e-hang-watchdog',
  );
  _watchdogPort = await port.first as SendPort;
  _heartbeatTimer =
      Timer.periodic(heartbeatEvery, (_) => _watchdogPort?.send(_heartbeat()));
  _watchdogPort!.send(_heartbeat());
  stderr.writeln('[e2e ${_clock()}] watchdog armed '
      '(heartbeat stall ${heartbeatStall.inSeconds}s, '
      'step stall ${stepStall.inSeconds}s)');
}

/// Marks a step of the test: a timestamped line on stderr, live, plus the
/// watchdog's notion of progress. Cheap; call it at every stop.
void traceStep(String step) {
  _lastStep = step;
  _lastStepAt = DateTime.now();
  stderr.writeln('[e2e ${_clock()}] $step');
  _watchdogPort?.send(_heartbeat());
}

String _lastStep = 'not started';
DateTime _lastStepAt = DateTime.now();
SendPort? _watchdogPort;
Isolate? _watchdogIsolate;
Timer? _heartbeatTimer;
Map<String, Object?> Function()? _extraState;

/// Stops the watchdog (the manual try-out needs it to let the process exit;
/// the integration tests end with the app process and never call it).
void stopHangWatchdog() {
  _heartbeatTimer?.cancel();
  _heartbeatTimer = null;
  _watchdogIsolate?.kill(priority: Isolate.immediate);
  _watchdogIsolate = null;
  _watchdogPort = null;
}

String _clock() => DateTime.now().toIso8601String().substring(11, 19);

Map<String, Object?> _heartbeat() => {
      'step': _lastStep,
      'stepAt': _lastStepAt.millisecondsSinceEpoch,
      ...?_extraState?.call(),
    };

class _WatchdogConfig {
  const _WatchdogConfig({
    required this.reply,
    required this.wsUri,
    required this.mainIsolateId,
    required this.heartbeatStall,
    required this.stepStall,
    required this.repeatEvery,
  });
  final SendPort reply;
  final String? wsUri;
  final String? mainIsolateId;
  final Duration heartbeatStall;
  final Duration stepStall;
  final Duration repeatEvery;
}

Future<void> _watchdogMain(_WatchdogConfig config) async {
  final beats = ReceivePort();
  config.reply.send(beats.sendPort);
  Map<String, Object?> last = {};
  var lastBeatAt = DateTime.now();
  beats.listen((message) {
    last = (message as Map).cast<String, Object?>();
    lastBeatAt = DateTime.now();
  });
  DateTime? lastReportAt;
  final tick = Duration(seconds: (config.heartbeatStall.inSeconds ~/ 4).clamp(1, 10));
  while (true) {
    await Future<void>.delayed(tick);
    final now = DateTime.now();
    final sinceBeat = now.difference(lastBeatAt);
    final stepAtMs = last['stepAt'] as int?;
    final sinceStep = stepAtMs == null
        ? Duration.zero
        : now.difference(DateTime.fromMillisecondsSinceEpoch(stepAtMs));
    final beatStalled = sinceBeat > config.heartbeatStall;
    final stepStalled = sinceStep > config.stepStall;
    if (!beatStalled && !stepStalled) {
      lastReportAt = null;
      continue;
    }
    if (lastReportAt != null &&
        now.difference(lastReportAt) < config.repeatEvery) {
      continue;
    }
    lastReportAt = now;
    final extra = Map.of(last)..remove('step')..remove('stepAt');
    final out = StringBuffer()
      ..writeln('[e2e ${_clock()}] ===== WATCHDOG: the test looks stuck =====')
      ..writeln('  last step      : ${last['step']} '
          '(${sinceStep.inSeconds}s ago)')
      ..writeln('  last heartbeat : ${sinceBeat.inSeconds}s ago — '
          '${beatStalled ? "the main isolate is NOT running its event loop "
              "(synchronous loop, blocking native call or deadlock)" : "the main isolate is alive; the test awaits something that never completes"}')
      ..writeln('  state          : $extra');
    stderr.write(out);
    await _dumpMainIsolateStack(config);
    stderr.writeln('[e2e ${_clock()}] ===== end of watchdog report =====');
  }
}

Future<void> _dumpMainIsolateStack(_WatchdogConfig config) async {
  final wsUri = config.wsUri;
  final isolateId = config.mainIsolateId;
  if (wsUri == null || isolateId == null) {
    stderr.writeln('  (no VM service: no stack available)');
    return;
  }
  vms.VmService? service;
  try {
    service =
        await vmServiceConnectUri(wsUri).timeout(const Duration(seconds: 15));
    final stack = await service
        .getStack(isolateId, limit: 60)
        .timeout(const Duration(seconds: 20));
    final scripts = <String, vms.Script>{};
    Future<String> describe(vms.Frame f) async {
      final name = (f.code?.name ?? f.function?.name ?? '<unknown>')
          .replaceFirst(RegExp(r'^\[\w+\] '), '');
      final loc = f.location;
      if (loc == null) return name;
      var where = loc.script?.uri ?? '?';
      final scriptId = loc.script?.id;
      final tokenPos = loc.tokenPos;
      if (scriptId != null && tokenPos != null) {
        try {
          final script = scripts[scriptId] ??= (await service!
              .getObject(isolateId, scriptId)
              .timeout(const Duration(seconds: 5))) as vms.Script;
          final line = script.getLineNumberFromTokenPos(tokenPos);
          if (line != null) where = '$where:$line';
        } catch (_) {}
      }
      return '$name ($where)';
    }

    Future<void> printFrames(String title, List<vms.Frame>? frames) async {
      if (frames == null || frames.isEmpty) return;
      stderr.writeln('  --- $title');
      for (final f in frames) {
        if (f.kind == vms.FrameKind.kAsyncSuspensionMarker) {
          stderr.writeln('    <asynchronous suspension>');
          continue;
        }
        stderr.writeln('    #${f.index}  ${await describe(f)}');
      }
    }

    await printFrames('main isolate: sync frames', stack.frames);
    await printFrames(
        'main isolate: async causal frames', stack.asyncCausalFrames);
    if ((stack.frames?.isEmpty ?? true) &&
        (stack.asyncCausalFrames?.isEmpty ?? true)) {
      stderr.writeln('  main isolate has no Dart frames: idle in the event '
          'loop, waiting on a future/frame that never arrives');
    }
  } catch (e) {
    stderr.writeln('  (stack dump failed: $e — a main isolate blocked in '
        'native code cannot reach a safepoint; the native gdb dump in the '
        'workflow is the next stop)');
  } finally {
    await service?.dispose();
  }
}

/// Manual try-out, see [startHangWatchdog].
Future<void> main() async {
  await startHangWatchdog(
    heartbeatStall: const Duration(seconds: 8),
    stepStall: const Duration(seconds: 20),
    repeatEvery: const Duration(seconds: 10),
    heartbeatEvery: const Duration(seconds: 2),
  );
  traceStep('probe: spinning for 30 s');
  final end = DateTime.now().add(const Duration(seconds: 30));
  var n = 0;
  while (DateTime.now().isBefore(end)) {
    n++;
  }
  traceStep('probe: spun $n times, now awaiting a future that never completes');
  await Completer<void>().future.timeout(const Duration(seconds: 40),
      onTimeout: () => traceStep('probe: done'));
  stopHangWatchdog();
}
