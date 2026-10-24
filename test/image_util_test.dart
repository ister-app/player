import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';

Fragment$fragmentImages _image(String id, String type, {String? source, bool selected = false}) =>
    Fragment$fragmentImages.fromJson({
      '__typename': 'Image',
      'type': type,
      'id': id,
      'source': source,
      'selected': selected,
      'directory': {
        '__typename': 'Directory',
        'servingNode': {'__typename': 'Node', 'url': 'http://localhost'},
      },
    });

void main() {
  test('local artwork wins over scraped provider images', () {
    final images = [
      _image('tmdb-cover', 'COVER', source: 'TMDB'),
      _image('tmdb-background', 'BACKGROUND', source: 'TMDB'),
      _image('local-cover', 'COVER', source: 'LOCAL_FILE'),
      _image('local-background', 'BACKGROUND', source: 'LOCAL_FILE'),
    ];
    expect(ImageUtil.getImageByType(images, ImageTypes.cover)?.id,
        'local-cover');
    expect(ImageUtil.getImageByType(images, ImageTypes.background)?.id,
        'local-background');
  });

  test('sourceless artwork (older servers) also beats provider images', () {
    final images = [
      _image('tmdb-cover', 'COVER', source: 'TMDB'),
      _image('local-cover', 'COVER'),
    ];
    expect(ImageUtil.getImageByType(images, ImageTypes.cover)?.id,
        'local-cover');
  });

  test('falls back to a provider image when no local one exists', () {
    final images = [_image('tmdb-cover', 'COVER', source: 'TMDB')];
    expect(
        ImageUtil.getImageByType(images, ImageTypes.cover)?.id, 'tmdb-cover');
    expect(ImageUtil.getImageByType(images, ImageTypes.background), isNull);
  });

  test('the pick does not depend on the order the server returns', () {
    // Two scraped backgrounds, as the server hands them back in whatever
    // order the database feels like — every query must agree on one.
    final a = _image('bg-a', 'BACKGROUND', source: 'TMDB');
    final b = _image('bg-b', 'BACKGROUND', source: 'TMDB');
    expect(ImageUtil.getImageByType([a, b], ImageTypes.background)?.id, 'bg-a');
    expect(ImageUtil.getImageByType([b, a], ImageTypes.background)?.id, 'bg-a');

    // A local one still beats a scraped one with a smaller id, either way round.
    final local = _image('zz-local', 'BACKGROUND', source: 'LOCAL_FILE');
    expect(ImageUtil.getImageByType([a, local], ImageTypes.background)?.id,
        'zz-local');
    expect(ImageUtil.getImageByType([local, a], ImageTypes.background)?.id,
        'zz-local');
  });

  test("an admin's selected image wins over local files and lower ids", () {
    final local = _image('aa-local', 'COVER', source: 'LOCAL_FILE');
    final lowId = _image('ab-tmdb', 'COVER', source: 'TMDB');
    final chosen = _image('zz-chosen', 'COVER', source: 'TMDB', selected: true);
    expect(ImageUtil.getImageByType([local, lowId, chosen], ImageTypes.cover)?.id, 'zz-chosen');
    expect(ImageUtil.getImageByType([chosen, lowId, local], ImageTypes.cover)?.id, 'zz-chosen');
    // The choice is per type: the background is still picked automatically.
    final bg = _image('bg', 'BACKGROUND', source: 'TMDB');
    expect(ImageUtil.getImageByType([chosen, bg], ImageTypes.background)?.id, 'bg');
  });

  test('handles null and empty lists', () {
    expect(ImageUtil.getImageByType(null, ImageTypes.cover), isNull);
    expect(ImageUtil.getImageByType([], ImageTypes.cover), isNull);
  });

  group('cacheKeyFor', () {
    test('drops a token that is the only parameter', () {
      expect(ImageUtil.cacheKeyFor('http://n/images/i/download?token=abc'),
          'http://n/images/i/download');
    });

    test('keeps the other parameters, whatever the order', () {
      expect(ImageUtil.cacheKeyFor('http://n/comic/m/page/3?width=240&token=abc'),
          'http://n/comic/m/page/3?width=240');
      expect(ImageUtil.cacheKeyFor('http://n/comic/m/page/3?token=abc&width=240'),
          'http://n/comic/m/page/3?width=240');
    });

    test('leaves urls without a token alone', () {
      expect(ImageUtil.cacheKeyFor('http://n/images/i/download'),
          'http://n/images/i/download');
      expect(ImageUtil.cacheKeyFor('https://is1-ssl.mzstatic.com/a.jpg?w=100'),
          'https://is1-ssl.mzstatic.com/a.jpg?w=100');
    });

    test('does not mistake another parameter for the token', () {
      expect(ImageUtil.cacheKeyFor('https://x/a.jpg?auth_token=abc'),
          'https://x/a.jpg?auth_token=abc');
    });

    test('strips a url-encoded token value (epub resources encode theirs)', () {
      expect(ImageUtil.cacheKeyFor('http://n/epub/m/resource/a%2Fb.jpg?token=a%3Db'),
          'http://n/epub/m/resource/a%2Fb.jpg');
    });

    test('passes local and file urls through', () {
      expect(ImageUtil.cacheKeyFor('file:///home/u/art.jpg'), 'file:///home/u/art.jpg');
      expect(ImageUtil.cacheKeyFor('/data/user/0/app/cover.jpg'),
          '/data/user/0/app/cover.jpg');
    });

    test('null and empty come back null so they can feed cacheKey:', () {
      expect(ImageUtil.cacheKeyFor(null), isNull);
      expect(ImageUtil.cacheKeyFor(''), isNull);
    });

    test('two tokens for the same image yield one key', () {
      final image = _image('cover-1', 'COVER');
      expect(
          ImageUtil.cacheKeyFor(ImageUtil.buildUrl(image, token: 'tok-a')),
          ImageUtil.cacheKeyFor(ImageUtil.buildUrl(image, token: 'tok-b')));
      // ...and it is the very url the downloads already store as artworkUrl.
      expect(ImageUtil.cacheKeyFor(ImageUtil.buildUrl(image, token: 'tok-a')),
          ImageUtil.buildUrl(image));
    });
  });

  test('an image type this build does not know is skipped, not thrown on', () {
    final images = [
      _image('icon', 'ICON', source: 'LOCAL_FILE'),
      _image('cover', 'COVER', source: 'LOCAL_FILE'),
    ];
    expect(ImageUtil.getImageByType(images, ImageTypes.cover)?.id, 'cover');
    expect(ImageUtil.getImageByType([images.first], ImageTypes.cover), isNull);
  });
}
