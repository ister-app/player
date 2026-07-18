import 'package:audio_service/audio_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/utils/MediaPlayerHandler.dart';

void main() {
  MediaItem item(String? artUri) => MediaItem(
        id: 'srv;track;42',
        title: 'A track',
        artUri: artUri == null ? null : Uri.parse(artUri),
      );

  group('MediaPlayerHandler.restampArtToken', () {
    test('replaces an expired token in the artUri', () {
      final restamped = MediaPlayerHandler.restampArtToken(
        item('https://node.example/images/img-1/download?token=old'),
        'new',
      );
      expect(restamped.artUri.toString(),
          'https://node.example/images/img-1/download?token=new');
    });

    test('adds a token to a tokenless artUri', () {
      final restamped = MediaPlayerHandler.restampArtToken(
        item('https://node.example/images/img-1/download'),
        'new',
      );
      expect(restamped.artUri!.queryParameters['token'], 'new');
    });

    test('preserves unrelated query parameters', () {
      final restamped = MediaPlayerHandler.restampArtToken(
        item('https://node.example/images/img-1/download?size=large&token=old'),
        'new',
      );
      expect(restamped.artUri!.queryParameters['size'], 'large');
      expect(restamped.artUri!.queryParameters['token'], 'new');
    });

    test('returns the same instance when the token already matches', () {
      final original =
          item('https://node.example/images/img-1/download?token=fresh');
      expect(
          identical(
              MediaPlayerHandler.restampArtToken(original, 'fresh'), original),
          isTrue);
    });

    test('returns the same instance when there is no artwork', () {
      final original = item(null);
      expect(
          identical(MediaPlayerHandler.restampArtToken(original, 'new'),
              original),
          isTrue);
    });
  });
}
