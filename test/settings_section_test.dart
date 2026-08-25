import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player/components/SettingsSection.dart';

Widget _app(Widget child) => MaterialApp(home: Scaffold(body: child));

/// The building blocks in the order they lay out, top to bottom, keyed rather
/// than matched on text — this machine runs nl and CI runs en.
List<String> _typesInOrder(WidgetTester tester, Set<Type> wanted) {
  final found = <(double, String)>[];
  for (final element in tester.allElements) {
    final type = element.widget.runtimeType;
    if (!wanted.contains(type)) continue;
    final box = element.renderObject;
    if (box is! RenderBox || !box.attached) continue;
    found.add((box.localToGlobal(Offset.zero).dy, type.toString()));
  }
  found.sort((a, b) => a.$1.compareTo(b.$1));
  return found.map((e) => e.$2).toList();
}

void main() {
  group('SettingsSection', () {
    testWidgets('lays out header, hint and card in that order',
        (tester) async {
      await tester.pumpWidget(_app(const SettingsSection(
        title: 'Section',
        hint: 'What this section is for',
        children: [ListTile(title: Text('one'))],
      )));

      expect(
        _typesInOrder(tester,
            {SettingsSectionLabel, SettingsHint, SettingsCard}),
        ['SettingsSectionLabel', 'SettingsHint', 'SettingsCard'],
      );
    });

    testWidgets('renders no hint when none is given', (tester) async {
      await tester.pumpWidget(_app(const SettingsSection(
        title: 'Section',
        children: [ListTile(title: Text('one'))],
      )));

      expect(find.byType(SettingsHint), findsNothing);
    });
  });

  group('SettingsCard', () {
    testWidgets('divides between rows, never around them', (tester) async {
      await tester.pumpWidget(_app(const SettingsCard(children: [
        ListTile(title: Text('one')),
        ListTile(title: Text('two')),
        ListTile(title: Text('three')),
      ])));

      expect(find.byType(Divider), findsNWidgets(2));
    });

    testWidgets('a single row gets no divider', (tester) async {
      await tester.pumpWidget(_app(
          const SettingsCard(children: [ListTile(title: Text('one'))])));

      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('a collapsed trailing leaves no stray divider behind',
        (tester) async {
      // What AdminGate does when the user is not an admin.
      await tester.pumpWidget(_app(const SettingsCard(
        trailing: SizedBox.shrink(),
        children: [ListTile(title: Text('one'))],
      )));

      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('sits flush, not on the Material default margin',
        (tester) async {
      await tester.pumpWidget(_app(
          const SettingsCard(children: [ListTile(title: Text('one'))])));

      expect(tester.widget<Card>(find.byType(Card)).margin, EdgeInsets.zero);
    });
  });

  group('SettingsEmptyState', () {
    testWidgets('shows title and message', (tester) async {
      await tester.pumpWidget(_app(const SettingsEmptyState(
        icon: Icons.devices,
        title: 'Nothing here',
        message: 'Add something first',
      )));

      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Add something first'), findsOneWidget);
      expect(find.byIcon(Icons.devices), findsOneWidget);
    });

    testWidgets('the message is optional', (tester) async {
      await tester.pumpWidget(_app(const SettingsEmptyState(
        icon: Icons.devices,
        title: 'Nothing here',
      )));

      expect(find.text('Nothing here'), findsOneWidget);
    });
  });

  group('SettingsErrorState', () {
    testWidgets('leads with the sentence and hides the exception',
        (tester) async {
      await tester.pumpWidget(_app(const SettingsErrorState(
        message: 'Could not load this page',
        detailsLabel: 'Technical details',
        details: 'OperationException(linkException: …)',
      )));

      expect(find.text('Could not load this page'), findsOneWidget);
      expect(find.text('Technical details'), findsOneWidget);
      // Collapsed: the raw exception is reachable, never the headline.
      expect(find.textContaining('OperationException'), findsNothing);

      await tester.tap(find.text('Technical details'));
      await tester.pumpAndSettle();
      expect(find.textContaining('OperationException'), findsOneWidget);
    });

    testWidgets('shows no disclosure when there is nothing to disclose',
        (tester) async {
      await tester.pumpWidget(_app(const SettingsErrorState(
        message: 'Could not load this page',
        detailsLabel: 'Technical details',
      )));

      expect(find.text('Technical details'), findsNothing);
    });
  });
}
