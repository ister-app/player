import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/CarouselItemView.dart';

Widget _tile({required double width, required double height}) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: width,
          height: height,
          child: const CarouselItemView(
            serverName: 'test',
            title: 'Attack on Titan: een behoorlijk lange titel',
            subTitle: 'Volume 1',
          ),
        ),
      ),
    ),
  );
}

void main() {
  Text titleText(WidgetTester tester) => tester.widget<Text>(
      find.text('Attack on Titan: een behoorlijk lange titel'));

  testWidgets('short grid cell drops to the compact text styles',
      (tester) async {
    await tester.pumpWidget(_tile(width: 210, height: 140));
    final theme = Theme.of(tester.element(find.byType(CarouselItemView)));
    final title = titleText(tester);
    expect(title.style?.fontSize, theme.textTheme.titleMedium?.fontSize);
    expect(title.overflow, TextOverflow.ellipsis);
  });

  testWidgets('landscape tile in a 200-tall carousel row keeps the large style',
      (tester) async {
    await tester.pumpWidget(_tile(width: 300, height: 200));
    final theme = Theme.of(tester.element(find.byType(CarouselItemView)));
    final title = titleText(tester);
    expect(title.style?.fontSize, theme.textTheme.headlineMedium?.fontSize);
    expect(title.overflow, TextOverflow.ellipsis);
  });

  testWidgets(
      'narrow book tile in the same 200-tall row also keeps the large style',
      (tester) async {
    await tester.pumpWidget(_tile(width: 133, height: 200));
    final theme = Theme.of(tester.element(find.byType(CarouselItemView)));
    final title = titleText(tester);
    expect(title.style?.fontSize, theme.textTheme.headlineMedium?.fontSize);
  });
}
