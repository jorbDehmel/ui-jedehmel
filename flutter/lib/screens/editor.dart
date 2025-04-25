import "dart:io";
import "package:flutter/material.dart";
import "package:re_editor/re_editor.dart";
import "package:re_highlight/languages/markdown.dart";
import "package:re_highlight/styles/base16/dark-violet.dart";
import "../widgets/export.dart";

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, required this.filepath});
  final String filepath;

  @override
  State<StatefulWidget> createState() => EditorPageState(filepath: filepath);
}

class EditorPageState extends State<EditorPage> {
  EditorPageState({required this.filepath});
  final String filepath;

  final controller = CodeLineEditingController();

  @override
  Widget build(BuildContext context) {
    final f = File(filepath);
    if (f.existsSync()) {
      f.readAsString().then((str) {
        setState(() {
          controller.text = str;
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(filepath),
        actions: [
          ElevatedButton(
            key: ValueKey('editor.save'),
            onPressed: () async {
              // Save file
              await File(filepath).writeAsString(controller.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: CodeEditor(
        controller: controller,
        autocompleteSymbols: false,
        autofocus: true,
        wordWrap: false,
        style: CodeEditorStyle(
          fontSize: 20.0,
          codeTheme: CodeHighlightTheme(
            languages: {'json': CodeHighlightThemeMode(mode: langMarkdown)},
            theme: darkVioletTheme,
          ),
        ),
        indicatorBuilder: (
          context,
          editingController,
          chunkController,
          notifier,
        ) {
          return Row(
            children: [
              DefaultCodeLineNumber(
                controller: editingController,
                notifier: notifier,
              ),
              DefaultCodeChunkIndicator(
                width: 20,
                controller: chunkController,
                notifier: notifier,
              ),
            ],
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        key: ValueKey('editor.export'),
        onPressed: () async {
          // Save file
          await File(filepath).writeAsString(controller.text);
          showDialog(
            context: context,
            builder: (context) => Export(filepath: filepath),
          );
        },
        child: const Text('Export'),
      ),
    );
  }
}
