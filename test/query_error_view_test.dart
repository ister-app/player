import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:player/components/QueryErrorView.dart';
import 'package:player/l10n/app_localizations.dart';

Widget _app(Widget child) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  testWidgets('shows a headline and a retry, never the raw exception',
      (tester) async {
    var retried = 0;
    await tester.pumpWidget(_app(QueryErrorView(
      exception: 'OperationException(linkException: SocketException)',
      onRetry: () => retried++,
    )));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    // The exception is behind the details disclosure, not on the page.
    expect(find.textContaining('OperationException'), findsNothing);

    await tester.tap(find.byKey(QueryErrorView.retryKey));
    expect(retried, 1);

    await tester.tap(find.byKey(const ValueKey('settings-error-details')));
    await tester.pumpAndSettle();
    expect(find.textContaining('OperationException'), findsOneWidget);
  });

  testWidgets('without a retry callback there is no retry button',
      (tester) async {
    await tester.pumpWidget(_app(const QueryErrorView(exception: 'boom')));
    await tester.pumpAndSettle();
    expect(find.byKey(QueryErrorView.retryKey), findsNothing);
  });

  testWidgets('the compact form fits a row and retries', (tester) async {
    var retried = 0;
    await tester.pumpWidget(_app(Column(children: [
      QueryErrorView.compact(exception: 'boom', onRetry: () => retried++),
    ])));
    await tester.pumpAndSettle();
    expect(find.textContaining('boom'), findsNothing);
    await tester.tap(find.byKey(QueryErrorView.retryKey));
    expect(retried, 1);
    expect(tester.getSize(find.byType(QueryErrorView)).height, lessThan(80));
  });

  testWidgets('renders without localizations mounted', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: QueryErrorView(exception: 'boom', onRetry: () {}))));
    await tester.pumpAndSettle();
    expect(find.byKey(QueryErrorView.retryKey), findsOneWidget);
  });
}
