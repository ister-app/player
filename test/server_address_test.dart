import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/ServerAddress.dart';

void main() {
  test('strips scheme, whitespace and trailing slashes', () {
    expect(normalizeServerInput('  https://media.example.com/  '),
        'media.example.com');
    expect(normalizeServerInput('http://192.168.1.10:8080/api/'),
        '192.168.1.10:8080/api');
    expect(normalizeServerInput('localhost:8080/api'), 'localhost:8080/api');
  });

  test('rejects empty and inner whitespace', () {
    expect(normalizeServerInput(''), isNull);
    expect(normalizeServerInput('   '), isNull);
    expect(normalizeServerInput('https://'), isNull);
    expect(normalizeServerInput('media example.com'), isNull);
  });
}
