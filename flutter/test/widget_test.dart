import 'dart:convert';

import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jknit_gui/main.dart';
import 'package:jknit_gui/screens/editor.dart';
import 'package:jknit_gui/widgets/export.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';

// Skips the system dialogue
class DummyFileWrapper extends FileWrapper {
  @override
  var openFileFn = ({
    List<XTypeGroup>? acceptedTypeGroups,
    String? confirmButtonText,
    String? initialDirectory,
  }) async {
    return XFile("TESTING_FILE.jmd");
  };

  @override
  var getSaveLocationFn = ({
    List<XTypeGroup>? acceptedTypeGroups,
    String? confirmButtonText,
    String? initialDirectory,
    String? suggestedName,
  }) async {
    return FileSaveLocation("TESTING_FILE.jmd");
  };
}

// Overrides so we skip any system calls
class DummySystemWrapper extends SystemWrapper {
  @override
  var systemCall = (
    String executable,
    List<String> arguments, {
    Map<String, String>? environment,
    bool includeParentEnvironment = false,
    bool runInShell = false,
    Encoding? stderrEncoding,
    Encoding? stdoutEncoding,
    String? workingDirectory,
  }) {
    return ProcessResult(0, 0, "stdout", "stderr");
  };
}

void main() {
  SharedPreferencesAsyncPlatform.instance =
      InMemorySharedPreferencesAsync.empty();
  FileWrapper.instance = DummyFileWrapper();
  SystemWrapper.instance = DummySystemWrapper();

  testWidgets('New project navigation test', (WidgetTester tester) async {
    // We should be on the 'editor' page
    await tester.pumpWidget(const JKnitGUIApp());

    // Open new file
    expect(find.byKey(const Key('editor.menubar.file')), findsOneWidget);
    await tester.tap(find.byKey(const Key('editor.menubar.file')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('editor.menubar.file.new')), findsOneWidget);
    await tester.tap(find.byKey(const Key('editor.menubar.file.new')));
    await tester.pumpAndSettle();

    // Go to export page
    expect(find.byKey(const Key('editor.menubar.file')), findsOneWidget);
    await tester.tap(find.byKey(const Key('editor.menubar.file')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('editor.menubar.file.export')), findsOneWidget);
    await tester.tap(find.byKey(const Key('editor.menubar.file.export')));
    await tester.pumpAndSettle();
  });
}
