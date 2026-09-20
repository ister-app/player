import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/StreamTokenCookie.dart';

void main() {
  const origin = 'https://media.example';
  const server = '$origin/api';
  const token = '0b9f6c1e-0000-4000-8000-000000000001';
  const image = '$server/images/abc/download?width=320&token=$token';
  final expiry = DateTime.now().add(const Duration(hours: 24));

  late List<String> written;
  late String jar;

  /// A browser: same-origin page, and a jar that keeps what is written.
  void useBrowser({bool blocksCookies = false}) {
    StreamTokenCookie.pageOrigin = () => origin;
    StreamTokenCookie.writeCookie = (cookie) {
      written.add(cookie);
      if (!blocksCookies) jar = cookie.split(';').first;
    };
    StreamTokenCookie.readCookies = () => jar;
  }

  setUp(() {
    written = [];
    jar = '';
  });
  tearDown(StreamTokenCookie.resetForTest);

  test('native leaves urls alone', () {
    StreamTokenCookie.publish(server, token, expiry);
    expect(StreamTokenCookie.urlFor(image), image);
  });

  test('a same-origin server gets a strict cookie and tokenless urls', () {
    useBrowser();
    StreamTokenCookie.publish(server, token, expiry);

    expect(written.single, startsWith('IsterStreamToken=$token; Path=/api;'));
    expect(written.single, contains('SameSite=Strict'));
    expect(written.single, contains('Secure'));
    expect(StreamTokenCookie.urlFor(image),
        '$server/images/abc/download?width=320');
  });

  test('another origin keeps its token', () {
    useBrowser();
    StreamTokenCookie.publish('https://other.example/api', token, expiry);
    expect(written, isEmpty);

    StreamTokenCookie.publish(server, token, expiry);
    const node = 'https://node2.example/api/images/abc/download?token=$token';
    expect(StreamTokenCookie.urlFor(node), node);
  });

  test('a path outside the cookie keeps its token', () {
    useBrowser();
    StreamTokenCookie.publish(server, token, expiry);
    const sibling = '$origin/apiary/images/abc/download?token=$token';
    expect(StreamTokenCookie.urlFor(sibling), sibling);
  });

  test('a browser that drops the cookie keeps the token in the url', () {
    useBrowser(blocksCookies: true);
    StreamTokenCookie.publish(server, token, expiry);
    expect(StreamTokenCookie.urlFor(image), image);
  });

  test('an expired or cleared cookie no longer covers', () {
    useBrowser();
    StreamTokenCookie.publish(
        server, token, DateTime.now().subtract(const Duration(seconds: 1)));
    expect(StreamTokenCookie.urlFor(image), image);

    StreamTokenCookie.publish(server, token, expiry);
    StreamTokenCookie.clear(server);
    expect(written.last, contains('Max-Age=0'));
    expect(StreamTokenCookie.urlFor(image), image);
  });
}
