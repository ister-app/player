import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/ArtworkImage.dart';
import 'package:player/utils/ArtworkSizing.dart';
import 'package:player/utils/ImageUtil.dart';

const _artwork =
    'https://media.example.org/api/images/6674d588-0b94-43b6-b571-8acdcef64220/download';

void main() {
  group('bucketFor', () {
    test('snaps up to the smallest covering bucket', () {
      expect(ArtworkSizing.bucketFor(1), 160);
      expect(ArtworkSizing.bucketFor(160), 160);
      expect(ArtworkSizing.bucketFor(161), 240);
      expect(ArtworkSizing.bucketFor(390), 480);
      expect(ArtworkSizing.bucketFor(1280), 1280);
    });

    test('takes the original above the top bucket and for an unknown width', () {
      expect(ArtworkSizing.bucketFor(1281), isNull);
      expect(ArtworkSizing.bucketFor(0), isNull);
      expect(ArtworkSizing.bucketFor(-5), isNull);
    });
  });

  group('physicalWidth', () {
    test('multiplies by the device pixel ratio', () {
      expect(ArtworkSizing.physicalWidth(100, 1), 100);
      expect(ArtworkSizing.physicalWidth(100, 2), 200);
    });

    test('caps the ratio so a 4x phone does not decode 4x the pixels', () {
      expect(ArtworkSizing.physicalWidth(100, 4), 300);
    });

    test('is zero for a width we could not measure', () {
      expect(ArtworkSizing.physicalWidth(0, 3), 0);
      expect(ArtworkSizing.physicalWidth(double.infinity, 3), 0);
    });
  });

  group('sizedUrl', () {
    test('puts width first so the cache key is one per bucket', () {
      final sized = ArtworkSizing.sizedUrl('$_artwork?token=abc', 320);

      expect(sized, '$_artwork?width=320&token=abc');
      expect(ImageUtil.cacheKeyFor(sized), '$_artwork?width=320');
    });

    test('adds width to a url without parameters', () {
      expect(ArtworkSizing.sizedUrl(_artwork, 160), '$_artwork?width=160');
    });

    test('replaces a width that is already there', () {
      final once = ArtworkSizing.sizedUrl('$_artwork?token=abc', 640);
      final twice = ArtworkSizing.sizedUrl(once, 240);

      expect(twice, '$_artwork?width=240&token=abc');
    });

    test('is idempotent for the same bucket', () {
      final once = ArtworkSizing.sizedUrl('$_artwork?token=abc', 320);

      expect(ArtworkSizing.sizedUrl(once, 320), once);
    });

    test('strips an existing width when the original is wanted', () {
      final sized = ArtworkSizing.sizedUrl('$_artwork?token=abc', 640);

      expect(ArtworkSizing.sizedUrl(sized, null), '$_artwork?token=abc');
    });

    test('leaves everything that is not a server artwork download alone', () {
      const cases = [
        'file:///home/gerben/downloads/cover.jpg',
        '/var/data/cover.jpg',
        'https://is1-ssl.mzstatic.com/image/thumb/podcast.jpg',
        'https://media.example.org/api/comic/abc/page/3?token=abc',
        'https://media.example.org/api/epub/abc/resource/OEBPS/cover.jpg',
        'https://media.example.org/api/images/abc/download/extra',
      ];

      for (final url in cases) {
        expect(ArtworkSizing.sizedUrl(url, 320), url, reason: url);
      }
    });

    test('passes null and empty through', () {
      expect(ArtworkSizing.sizedUrl(null, 320), isNull);
      expect(ArtworkSizing.sizedUrl('', 320), '');
    });
  });

  group('ArtworkImage decode arguments', () {
    // The decode cap disappears inside OctoImage, so a widget test cannot see
    // it. Web deliberately gets none: memCacheWidth is a silent no-op under
    // its loader, and the ?width= on the url is what keeps the bytes (and so
    // the decode) small there.
    ArtworkImageDescription describe({required bool isWeb, double width = 150}) =>
        ArtworkImage.describeFor(
          url: '$_artwork?token=abc',
          logicalWidth: width,
          devicePixelRatio: 2,
          isWeb: isWeb,
        );

    test('native caps the decode with memCacheWidth', () {
      expect(describe(isWeb: false).memCacheWidth, 300);
    });

    test('web sets no decode cap, because none of them work there', () {
      expect(describe(isWeb: true).memCacheWidth, isNull);
    });

    test('web still asks the server for the smaller variant', () {
      expect(describe(isWeb: true).imageUrl, '$_artwork?width=320&token=abc');
    });

    test('asks the server for the bucket that covers the painted size', () {
      expect(describe(isWeb: false).imageUrl, '$_artwork?width=320&token=abc');
      expect(describe(isWeb: false).cacheKey, '$_artwork?width=320');
    });

    test('providerFor sizes the url and caps the decode off-widget', () {
      // The blurred backdrop and epub images have no layout to measure, so
      // they name a width.
      final provider = ArtworkImage.providerFor('$_artwork?token=abc',
          physicalWidth: 320) as ResizeImage;

      expect(provider.width, 320);
      expect(provider.allowUpscaling, isFalse);
      final inner = provider.imageProvider as CachedNetworkImageProvider;
      expect(inner.url, '$_artwork?width=320&token=abc');
      expect(inner.cacheKey, '$_artwork?width=320');
    });

    test('providerFor is null for no url, so callers can bail out', () {
      expect(ArtworkImage.providerFor(null, physicalWidth: 320), isNull);
      expect(ArtworkImage.providerFor('', physicalWidth: 320), isNull);
    });

    test('providerFor leaves a non-artwork url alone but still caps it', () {
      final provider = ArtworkImage.providerFor(
          'https://media.example.org/api/epub/abc/resource/img.png',
          physicalWidth: 1080) as ResizeImage;

      expect((provider.imageProvider as CachedNetworkImageProvider).url,
          'https://media.example.org/api/epub/abc/resource/img.png');
      expect(provider.width, 1080);
    });

    test('takes the original above the top bucket but still caps the decode', () {
      final huge = describe(isWeb: false, width: 900);

      expect(huge.imageUrl, '$_artwork?token=abc');
      expect(huge.memCacheWidth, 1800);
    });
  });
}
