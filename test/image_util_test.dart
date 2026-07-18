import 'package:flutter_test/flutter_test.dart';
import 'package:player/graphql/fragmentImages.graphql.dart';
import 'package:player/utils/ImageTypes.dart';
import 'package:player/utils/ImageUtil.dart';

Fragment$fragmentImages _image(String id, String type, {String? source}) =>
    Fragment$fragmentImages.fromJson({
      '__typename': 'Image',
      'type': type,
      'id': id,
      'source': source,
      'directory': {
        '__typename': 'Directory',
        'node': {'__typename': 'Node', 'url': 'http://localhost'},
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

  test('handles null and empty lists', () {
    expect(ImageUtil.getImageByType(null, ImageTypes.cover), isNull);
    expect(ImageUtil.getImageByType([], ImageTypes.cover), isNull);
  });
}
