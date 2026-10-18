import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/games/steam/Vdf.dart';

void main() {
  test('parses an appmanifest and looks up case-insensitively', () {
    const acf = '''
"AppState"
{
\t"appid"\t\t"413150"
\t"name"\t\t"Stardew Valley"
\t"installdir"\t\t"Stardew Valley"
\t"UserConfig"
\t{
\t\t"language"\t\t"english"
\t}
}
''';
    final state = Vdf.body(Vdf.parse(acf));
    expect(Vdf.integer(state, 'AppId'), 413150);
    expect(Vdf.string(state, 'installdir'), 'Stardew Valley');
    expect(Vdf.string(Vdf.map(state, 'userconfig')!, 'language'), 'english');
  });

  test('handles escapes, comments and unquoted tokens', () {
    const vdf = r'''
// comment
"libraryfolders"
{
	"0" { "path" "C:\\Program Files (x86)\\Steam" }
	1 { path "/home/me/.steam/steam" }
	"quoted" "say \"hi\""
}
''';
    final body = Vdf.body(Vdf.parse(vdf));
    expect(Vdf.string(Vdf.map(body, '0')!, 'path'), r'C:\Program Files (x86)\Steam');
    expect(Vdf.string(Vdf.map(body, '1')!, 'path'), '/home/me/.steam/steam');
    expect(Vdf.string(body, 'quoted'), 'say "hi"');
  });

  test('write produces a document parse reads back', () {
    final written = Vdf.write('AppState', {
      'appid': '1',
      'name': 'A "quoted" name',
      'UserConfig': {'language': 'english'},
    });
    final parsed = Vdf.body(Vdf.parse(written));
    expect(Vdf.string(parsed, 'name'), 'A "quoted" name');
    expect(Vdf.string(Vdf.map(parsed, 'UserConfig')!, 'language'), 'english');
    expect(written, contains('\t"appid"\t\t"1"'));
  });

  test('rejects unterminated input', () {
    expect(() => Vdf.parse('"a" { "b" "c"'), throwsFormatException);
    expect(() => Vdf.parse('"a" "unterminated'), throwsFormatException);
  });
}
