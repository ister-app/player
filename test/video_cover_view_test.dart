import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/VideoCoverView.dart';

void main() {
  Widget host(Widget child) => MaterialApp(
      home: Scaffold(body: SizedBox(width: 400, height: 300, child: child)));

  testWidgets('shows the play button and reports the tap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(VideoCoverView(
      serverName: 'srv',
      onPlay: () => taps++,
    )));
    expect(find.byKey(VideoCoverView.playButtonKey), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    await tester.tap(find.byKey(VideoCoverView.playButtonKey));
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('no button without onPlay (unplayable item)', (tester) async {
    await tester.pumpWidget(host(const VideoCoverView(serverName: 'srv')));
    expect(find.byKey(VideoCoverView.playButtonKey), findsNothing);
  });

  testWidgets('loading shows a spinner instead of the button', (tester) async {
    await tester.pumpWidget(
        host(const VideoCoverView(serverName: 'srv', loading: true)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byKey(VideoCoverView.playButtonKey), findsNothing);
  });
}
