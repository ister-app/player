import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/RatingStars.dart';
import 'package:player/graphql/schema.graphql.dart';
import 'package:player/l10n/app_localizations.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('hovering previews the value under the cursor', (tester) async {
    await tester.pumpWidget(wrap(const RatingStars(
      mediaType: Enum$RatingMediaType.MOVIE,
      mediaId: 'm1',
      rating: null,
    )));

    // Unrated: no value text, all stars empty.
    expect(find.textContaining('/10'), findsNothing);
    expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(5));

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);

    // Hover the right half of the third star → preview 6/10 (3 full stars).
    final thirdStar = tester.getCenter(find.byIcon(Icons.star_outline_rounded).at(2));
    await gesture.moveTo(thirdStar + const Offset(8, 0));
    await tester.pump();

    expect(find.text('6/10'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsNWidgets(3));
    expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(2));

    // Hover the left half of the same star → preview 5/10 (half star). The
    // centered row shifted when the value text appeared, so re-resolve the
    // star's position (index 2 among the five star icons).
    final thirdStarNow = tester.getCenter(find.byType(Icon).at(2));
    await gesture.moveTo(thirdStarNow - const Offset(8, 0));
    await tester.pump();

    expect(find.text('5/10'), findsOneWidget);
    expect(find.byIcon(Icons.star_half_rounded), findsOneWidget);

    // Leaving the stars clears the preview again.
    await gesture.moveTo(Offset.zero);
    await tester.pump();

    expect(find.textContaining('/10'), findsNothing);
    expect(find.byIcon(Icons.star_outline_rounded), findsNWidgets(5));
  });
}
