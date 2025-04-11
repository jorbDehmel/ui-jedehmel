import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jknit_gui/main.dart';

void main() {
  testWidgets('New project navigation test', (WidgetTester tester) async {
    WidgetController.hitTestWarningShouldBeFatal = true;

    await tester.pumpWidget(const JKnitGUIApp());

    // We should be on the 'main' page
    expect(find.widgetWithText(AppBar, 'JKnit Editor'), findsOneWidget);

    // Click 'New'
    await tester.tap(find.byKey(ValueKey('main.new')));
    await tester.pumpAndSettle();

    // Ensure we made it to 'New' widget
    expect(find.widgetWithText(AppBar, 'New Project'), findsOneWidget);

    // Get to editor
    await tester.tap(find.byKey(ValueKey('new.editor')));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'JKnit Project Editor'), findsOneWidget);

    // Go to export page
    await tester.tap(find.byKey(ValueKey('editor.export')));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Export Document'), findsOneWidget);

    // Export
    await tester.tap(find.byKey(ValueKey('export.export')));
    await tester.pumpAndSettle();
  });

  testWidgets('Help navigation test', (WidgetTester tester) async {
    WidgetController.hitTestWarningShouldBeFatal = true;

    await tester.pumpWidget(const JKnitGUIApp());

    // We should be on the 'main' page
    expect(find.widgetWithText(AppBar, 'JKnit Editor'), findsOneWidget);

    // Click 'Help'
    await tester.tap(find.byKey(ValueKey('main.help')));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(AppBar, 'Help'), findsOneWidget);

    // Find and use the search bar
    await tester.enterText(find.byKey(ValueKey('help.search')), 'search text');
    expect(find.widgetWithText(AppBar, 'search text'), findsOneWidget);
  });
}
