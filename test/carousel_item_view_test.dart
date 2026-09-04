import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/CarouselItemView.dart';

Widget _tile({
  required double width,
  required double height,
  String? imageUrl,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: width,
          height: height,
          child: CarouselItemView(
            serverName: 'test',
            title: 'Attack on Titan: een behoorlijk lange titel',
            subTitle: 'Volume 1',
            imageUrl: imageUrl,
          ),
        ),
      ),
    ),
  );
}

void main() {
  Text titleText(WidgetTester tester) => tester.widget<Text>(
    find.text('Attack on Titan: een behoorlijk lange titel'),
  );

  testWidgets('narrow grid cell drops to the compact text styles', (
    tester,
  ) async {
    await tester.pumpWidget(_tile(width: 133, height: 256));
    final theme = Theme.of(tester.element(find.byType(CarouselItemView)));
    final title = titleText(tester);
    expect(title.style?.fontSize, theme.textTheme.titleSmall?.fontSize);
    expect(title.overflow, TextOverflow.ellipsis);
  });

  testWidgets('wide tile in a carousel row keeps the large style', (
    tester,
  ) async {
    await tester.pumpWidget(_tile(width: 300, height: 256));
    final theme = Theme.of(tester.element(find.byType(CarouselItemView)));
    final title = titleText(tester);
    expect(title.style?.fontSize, theme.textTheme.titleMedium?.fontSize);
    expect(title.overflow, TextOverflow.ellipsis);
  });

  testWidgets('caption sits below the artwork instead of over it', (
    tester,
  ) async {
    await tester.pumpWidget(_tile(width: 300, height: 256));
    final artRect = tester.getRect(
      find.byKey(const ValueKey('carousel-item-art')),
    );
    final titleRect = tester.getRect(
      find.text('Attack on Titan: een behoorlijk lange titel'),
    );
    expect(titleRect.top, greaterThanOrEqualTo(artRect.bottom));
  });

  testWidgets('progress bar renders inside the artwork, above the caption', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 300,
              height: 256,
              child: CarouselItemView(
                serverName: 'test',
                title: 'Attack on Titan: een behoorlijk lange titel',
                subTitle: 'Volume 1',
                progress: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
    final artRect = tester.getRect(
      find.byKey(const ValueKey('carousel-item-art')),
    );
    final barRect = tester.getRect(find.byType(LinearProgressIndicator));
    expect(barRect.bottom, moreOrLessEquals(artRect.bottom));
    final titleRect = tester.getRect(
      find.text('Attack on Titan: een behoorlijk lange titel'),
    );
    expect(barRect.bottom, lessThanOrEqualTo(titleRect.top));
  });

  testWidgets('the cache key drops the stream token, the url keeps it', (
    tester,
  ) async {
    // A token is minted per app start and rotates within one, so keying the
    // image cache on the full url stored one copy per token.
    await tester.pumpWidget(
      _tile(
        width: 210,
        height: 300,
        imageUrl: 'http://node/images/img-1/download?token=tok-1',
      ),
    );
    final first = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );
    expect(
      first.imageUrl,
      'http://node/images/img-1/download?width=640&token=tok-1',
    );
    expect(first.cacheKey, 'http://node/images/img-1/download?width=640');

    await tester.pumpWidget(
      _tile(
        width: 210,
        height: 300,
        imageUrl: 'http://node/images/img-1/download?token=tok-2',
      ),
    );
    final second = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );
    expect(second.cacheKey, first.cacheKey);
  });

  testWidgets('the artwork is fetched at the width the tile paints it', (
    tester,
  ) async {
    // A phone grid cell and a desktop carousel tile must not both pull the
    // stored original: that is what filled the browser's GPU memory and left
    // tiles grey. The widths below are the tile minus its 5dp padding, times
    // the test binding's device pixel ratio of 3, snapped to a bucket.
    await tester.pumpWidget(
      _tile(
        width: 133,
        height: 256,
        imageUrl: 'http://node/images/img-1/download?token=tok',
      ),
    );
    expect(
      tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage)).cacheKey,
      'http://node/images/img-1/download?width=480',
    );

    await tester.pumpWidget(
      _tile(
        width: 300,
        height: 400,
        imageUrl: 'http://node/images/img-1/download?token=tok',
      ),
    );
    expect(
      tester.widget<CachedNetworkImage>(find.byType(CachedNetworkImage)).cacheKey,
      'http://node/images/img-1/download?width=960',
    );
  });
}
