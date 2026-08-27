import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/ScreenWakelock.dart';

/// The wakelock is one global flag shared by both readers and, on iOS, the
/// download queue — so the counting is what keeps the last releaser from
/// dropping somebody else's hold. The plugin itself is absent under
/// `flutter test`; `ScreenWakelock` swallows that, which is also what these
/// tests rely on.
void main() {
  tearDown(() {
    // Nothing should leak between tests.
    expect(ScreenWakelock.holders, 0);
  });

  test('a single holder acquires and releases', () {
    final token = ScreenWakelock.acquire();
    expect(ScreenWakelock.holders, 1);
    token.release();
    expect(ScreenWakelock.holders, 0);
  });

  test('the lock survives until the last holder releases', () {
    final reader = ScreenWakelock.acquire();
    final download = ScreenWakelock.acquire();
    expect(ScreenWakelock.holders, 2);

    // Closing the reader must not drop the download's hold.
    reader.release();
    expect(ScreenWakelock.holders, 1);

    download.release();
    expect(ScreenWakelock.holders, 0);
  });

  test('releasing a token twice does not free somebody else\'s hold', () {
    final first = ScreenWakelock.acquire();
    final second = ScreenWakelock.acquire();

    first.release();
    first.release();
    expect(ScreenWakelock.holders, 1);

    second.release();
    expect(ScreenWakelock.holders, 0);
  });
}
