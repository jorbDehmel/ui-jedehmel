import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jknit_gui/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('New project navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(const JKnitGUIApp());
    // We should be on the 'editor' page

    // Open new file
    await tester.press(find.byKey(const ValueKey('editor.menubar.file')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('editor.menubar.file.new')),
      findsOneWidget,
    );
    await tester.press(find.byKey(const ValueKey('editor.menubar.file.new')));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);

    // Go to export page
    await tester.press(find.byKey(const ValueKey('editor.menubar.file')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('editor.menubar.file.export')),
      findsOneWidget,
    );
    await tester.press(
      find.byKey(const ValueKey('editor.menubar.file.export')),
    );

    // Export
    await tester.press(find.byKey(const ValueKey('export.export')));
    await tester.pumpAndSettle();
  });
}
