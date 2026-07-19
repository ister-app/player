import 'package:flutter_test/flutter_test.dart';
import 'package:player/dto/IsterMediaItem.dart';
import 'package:player/dto/IsterMediaService.dart';
import 'package:player/dto/MediaItemId.dart';

/// The Android Auto browse tree encodes everything a leaf needs to play in its
/// node id ([MediaItemId] string). Audiobook chapters and podcast episodes each
/// need two server ids, joined by [IsterMediaService.compositeIdSeparator]; the
/// player parses them back in `playFromMediaId`. These tests pin that scheme so
/// a browse id always resolves to a playable pair.
void main() {
  group('MediaItemId round-trips the browse media types', () {
    for (final type in IsterMediaTypes.values) {
      test('$type survives toString/byStringId', () {
        final id = MediaItemId('localhost:8080/api', type, 'the-id-42');
        final parsed = MediaItemId.byStringId(id.toString());
        expect(parsed.serverName, 'localhost:8080/api');
        expect(parsed.isterMediaType, type);
        expect(parsed.id, 'the-id-42');
      });
    }
  });

  group('composite leaf ids carry both server ids', () {
    test('audiobook chapter id splits into bookId and chapterId', () {
      const bookId = 'b1111111-2222-3333-4444-555555555555';
      const chapterId = 'c9999999-8888-7777-6666-555555555555';
      final leaf = MediaItemId(
        'localhost:8080/api',
        IsterMediaTypes.chapter,
        '$bookId${IsterMediaService.compositeIdSeparator}$chapterId',
      );

      final parsed = MediaItemId.byStringId(leaf.toString());
      final parts =
          parsed.id.split(IsterMediaService.compositeIdSeparator);
      expect(parsed.isterMediaType, IsterMediaTypes.chapter);
      expect(parts, [bookId, chapterId]);
    });

    test('podcast episode id splits into podcastId and episodeId', () {
      const podcastId = 'p1111111-2222-3333-4444-555555555555';
      const episodeId = 'e9999999-8888-7777-6666-555555555555';
      final leaf = MediaItemId(
        'localhost:8080/api',
        IsterMediaTypes.podcastEpisode,
        '$podcastId${IsterMediaService.compositeIdSeparator}$episodeId',
      );

      final parsed = MediaItemId.byStringId(leaf.toString());
      final parts =
          parsed.id.split(IsterMediaService.compositeIdSeparator);
      expect(parsed.isterMediaType, IsterMediaTypes.podcastEpisode);
      expect(parts, [podcastId, episodeId]);
    });

    test('the composite separator does not collide with the id separator', () {
      // MediaItemId joins on ";"; the composite id must use something else, or
      // parsing the outer id would break.
      expect(IsterMediaService.compositeIdSeparator, isNot(contains(';')));
    });
  });
}
