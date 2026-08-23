import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:player/l10n/app_localizations.dart';
import 'package:player/routes/AppRouter.gr.dart';
import 'package:player/utils/ClientManager.dart';
import 'package:player/utils/ServerAddress.dart';
import 'package:player/utils/ServerStore.dart';
import 'package:player/utils/WellKnownService.dart';

enum _Step { idle, invalid, probing, found, notIster, unreachable, duplicate }

/// Guided add-server flow: type an address, the app probes it and shows what
/// it found (name and API url) before anything is saved. Every failure is
/// explained in place instead of leaving a grey "unreachable" card behind on
/// the overview. With [firstRun] it doubles as the welcome screen.
@RoutePage()
class AddServerPage extends StatefulWidget {
  const AddServerPage({super.key, this.firstRun = false});

  final bool firstRun;

  @override
  State<AddServerPage> createState() => _AddServerPageState();
}

class _AddServerPageState extends State<AddServerPage> {
  final _controller = TextEditingController();
  _Step _step = _Step.idle;
  String _server = '';
  WellKnownInfo? _info;
  int _probeGeneration = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _connect() async {
    final server = normalizeServerInput(_controller.text);
    if (server == null) {
      setState(() => _step = _Step.invalid);
      return;
    }
    final generation = ++_probeGeneration;
    setState(() {
      _server = server;
      _info = null;
      _step = _Step.probing;
    });
    if (await ServerStore.contains(server)) {
      if (!mounted || generation != _probeGeneration) return;
      setState(() => _step = _Step.duplicate);
      return;
    }
    final probe = await WellKnownService.probe(server);
    if (!mounted || generation != _probeGeneration) return;
    setState(() {
      switch (probe.status) {
        case WellKnownProbeStatus.found:
          _info = probe.info;
          _step = _Step.found;
        case WellKnownProbeStatus.notIster:
          _step = _Step.notIster;
        case WellKnownProbeStatus.unreachable:
          _step = _Step.unreachable;
      }
    });
  }

  Future<void> _addAndOpen() async {
    await ServerStore.add(_server);
    if (!mounted) return;
    _open(_server);
  }

  void _open(String server) {
    // Same recipe as ServerList.goToServerRoute: remember the pick so the
    // next cold start lands here again. replace() so back never returns to
    // this form.
    ClientManager.instance.lastClientUsed = server;
    AutoRouter.of(context).replace(ServerHomeRoute(serverName: server));
  }

  void _edit() {
    _probeGeneration++;
    setState(() => _step = _Step.idle);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final busy = _step == _Step.probing;
    final editing = _step != _Step.found && _step != _Step.duplicate;

    return Scaffold(
      appBar: AppBar(title: Text(loc.addServerTitle)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.firstRun) ...[
                  // The overview already showed the logo; keep this compact.
                  Text(loc.welcomeTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(loc.welcomeBody,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 32),
                ],
                TextField(
                  controller: _controller,
                  autofocus: true,
                  enabled: editing && !busy,
                  keyboardType: TextInputType.url,
                  autocorrect: false,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (_) => _connect(),
                  onChanged: (_) {
                    if (_step != _Step.idle) setState(() => _step = _Step.idle);
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: loc.serverAddressLabel,
                    helperText: loc.serverAddressExamples,
                    helperMaxLines: 2,
                    prefixIcon: const Icon(Icons.dns),
                    errorText: _errorText(loc),
                    errorMaxLines: 3,
                  ),
                ),
                const SizedBox(height: 16),
                if (editing)
                  FilledButton.icon(
                    onPressed: busy ? null : _connect,
                    icon: busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.link),
                    label: Text(busy ? loc.connecting(_server) : loc.connect),
                  ),
                if (_step == _Step.found) ..._foundSection(loc, theme),
                if (_step == _Step.duplicate) ..._duplicateSection(loc, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _errorText(AppLocalizations loc) {
    switch (_step) {
      case _Step.invalid:
        return loc.serverAddressInvalid;
      case _Step.notIster:
        return loc.notAnIsterServer;
      case _Step.unreachable:
        return loc.serverUnreachableHint(_server);
      default:
        return null;
    }
  }

  List<Widget> _foundSection(AppLocalizations loc, ThemeData theme) {
    final info = _info!;
    return [
      const SizedBox(height: 8),
      Text(loc.serverFound, style: theme.textTheme.titleMedium),
      const SizedBox(height: 8),
      Card(
        child: ListTile(
          leading: ServerAvatar(name: info.name),
          title: Text(info.name),
          subtitle: Text(info.serverUrl),
        ),
      ),
      const SizedBox(height: 16),
      FilledButton.icon(
        onPressed: _addAndOpen,
        icon: const Icon(Icons.login),
        label: Text(loc.addAndSignIn),
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: _edit,
        child: Text(MaterialLocalizations.of(context).backButtonTooltip),
      ),
    ];
  }

  List<Widget> _duplicateSection(AppLocalizations loc, ThemeData theme) {
    return [
      const SizedBox(height: 8),
      Card(
        color: theme.colorScheme.surfaceContainerHighest,
        child: ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text(loc.serverAlreadyAdded),
          subtitle: Text(_server),
        ),
      ),
      const SizedBox(height: 16),
      FilledButton.icon(
        onPressed: () => _open(_server),
        icon: const Icon(Icons.arrow_forward),
        label: Text(loc.open),
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: _edit,
        child: Text(MaterialLocalizations.of(context).backButtonTooltip),
      ),
    ];
  }
}

/// A round badge with the first letter of a server's name — the visual
/// identity a server gets everywhere it is listed.
class ServerAvatar extends StatelessWidget {
  const ServerAvatar({super.key, required this.name, this.muted = false});

  final String name;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final letter = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return CircleAvatar(
      backgroundColor:
          muted ? colors.surfaceContainerHighest : colors.primaryContainer,
      foregroundColor:
          muted ? colors.onSurfaceVariant : colors.onPrimaryContainer,
      child: Text(letter, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
