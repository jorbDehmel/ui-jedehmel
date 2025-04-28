import "dart:io";
import "package:flutter/material.dart";
import "package:re_editor/re_editor.dart";
import "package:re_highlight/languages/markdown.dart";
import "package:re_highlight/styles/base16/ia-light.dart";
import "package:re_highlight/styles/base16/mexico-light.dart";
import "package:re_highlight/styles/shades-of-purple.dart";
import "package:re_highlight/styles/stackoverflow-light.dart";
import "package:re_highlight/styles/tokyo-night-light.dart";
import "package:re_highlight/styles/xcode.dart";
import "../widgets/export.dart";

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, required this.filepath});
  final String filepath;

  @override
  State<StatefulWidget> createState() => EditorPageState(filepath: filepath);
}

class EditorPageState extends State<EditorPage> {
  EditorPageState({required this.filepath}) {
    final f = File(filepath);
    if (f.existsSync()) {
      f.readAsString().then((str) {
        setState(() {
          controller.text = str;
        });
      });
    } else {
      // Default file contents
      controller.text =
          "\n# Hello, world!\n\nHere is some normal text.\n"
          "The following is running `python` code.\n\n"
          "```python\nprint('Hello, world!')\n```\n\n"
          "When exported, the output will be inserted here.\n";
    }
  }

  final String filepath;

  final controller = CodeLineEditingController();

  @override
  Widget build(BuildContext context) {
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
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [Text('Your file has been saved.')],
                      ),
                    ),
              );
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
          fontFamily: 'mono',
          fontSize: 24.0,
          codeTheme: CodeHighlightTheme(
            languages: {'json': CodeHighlightThemeMode(mode: langMarkdown)},
            theme: stackoverflowLightTheme,
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
