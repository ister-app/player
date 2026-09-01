import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/CarouselItemView.dart';
import 'package:player/components/MediaGrid.dart';

void main() {
  Future<BuildContext> pumpContext(
    WidgetTester tester, {
    double textScale = 1.0,
  }) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
          child: Builder(
            builder: (c) {
              context = c;
              return const SizedBox();
            },
          ),
        ),
      ),
    );
    return context;
  }

  SliverGridDelegateWithFixedCrossAxisCount delegate(
    BuildContext context,
    double width, {
    double artAspectRatio = 1.0,
  }) =>
      mediaGridDelegate(context, width, artAspectRatio: artAspectRatio)
          as SliverGridDelegateWithFixedCrossAxisCount;

  testWidgets('phone width gets at least three columns', (tester) async {
    final context = await pumpContext(tester);
    expect(delegate(context, 400).crossAxisCount, 3);
    expect(delegate(context, 360).crossAxisCount, 3);
  });

  testWidgets('wide layouts keep the old ceil(width / 300) column count', (
    tester,
  ) async {
    final context = await pumpContext(tester);
    expect(delegate(context, 1200).crossAxisCount, 4);
    expect(delegate(context, 901).crossAxisCount, 4);
    expect(delegate(context, 900).crossAxisCount, 3);
  });

  testWidgets('just under the 600dp breakpoint still forces three columns', (
    tester,
  ) async {
    final context = await pumpContext(tester);
    expect(delegate(context, 599).crossAxisCount, 3);
    expect(delegate(context, 600).crossAxisCount, 2);
  });

  testWidgets('cell height is the art height plus the caption', (tester) async {
    final context = await pumpContext(tester);
    final caption = CarouselItemView.captionHeightOf(context);
    expect(delegate(context, 900).mainAxisExtent, 300 + caption);
    expect(
      delegate(context, 900, artAspectRatio: 2 / 3).mainAxisExtent,
      450 + caption,
    );
  });

  testWidgets('caption and cell grow with the text scale', (tester) async {
    final normal = await pumpContext(tester);
    final normalCaption = CarouselItemView.captionHeightOf(normal);
    final normalExtent = delegate(normal, 900).mainAxisExtent!;

    final scaled = await pumpContext(tester, textScale: 1.5);
    final scaledCaption = CarouselItemView.captionHeightOf(scaled);
    expect(scaledCaption, greaterThan(normalCaption));
    expect(
      delegate(scaled, 900).mainAxisExtent,
      normalExtent - normalCaption + scaledCaption,
    );
  });
}
