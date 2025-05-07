import "dart:io";
import "package:file_selector/file_selector.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:jknit_gui/screens/help.dart";
import "package:jknit_gui/widgets/export.dart";
import "package:jknit_gui/widgets/options.dart";
import "package:re_editor/re_editor.dart";
import "package:re_highlight/languages/markdown.dart";
import "package:re_highlight/styles/stackoverflow-light.dart";

const defaultText =
    "\n# Hello, world!\n\nHere is some normal text.\n"
    "The following is running `python` code.\n\n"
    "```python\nprint('Hello, world!')\n```\n\n"
    "When exported, the output will be inserted here.\n";

class FileWrapper {
  var openFileFn = openFile;
  var getSaveLocationFn = getSaveLocation;

  static FileWrapper instance = FileWrapper();
}

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, required this.filepath});
  final String? filepath;

  @override
  State<StatefulWidget> createState() => EditorPageState(filepath);
}

class EditorPageState extends State<EditorPage> {
  late String filepath;
  List<String> recent = [];
  final controller = CodeLineEditingController();

  EditorPageState(String? inputFilepath) {
    if (inputFilepath == null) {
      // Load most recent file as filepath
      filepath = 'untitled.jmd';

      loadPreferences().then((prefs) {
        final recentFiles = prefs.getStringList('recent');
        if (recentFiles != null && recentFiles.isNotEmpty) {
          setState(() {
            filepath = recentFiles.first;
          });
        }
      });
    } else {
      filepath = inputFilepath;
    }

    final f = File(filepath);
    if (f.existsSync()) {
      f.readAsString().then((str) {
        setState(() {
          controller.text = str;
        });
      });
    } else {
      // Default file contents
      controller.text = defaultText;
    }

    loadPreferences().then((prefs) {
      setState(() {
        // Get list of previous recents
        if (!prefs.containsKey('recent')) {
          prefs.setStringList('recent', []);
        }
        recent = prefs.getStringList('recent')!;

        // Add the newest file to the beginning and trim as needed
        recent.remove(filepath);
        recent.insert(0, filepath);
        while (recent.length > 10) {
          recent.removeLast();
        }

        // Write back to settings
        prefs.setStringList('recent', recent);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final editor = CodeEditor(
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
    );

    optionsFn() {
      openOptionsScreen(context);
    }

    saveFn() {
      // Save file
      if (controller.text.isNotEmpty) {
        File(filepath).writeAsString(controller.text).then((_) {
          setState(() {
            showDialog(
              context: context,
              builder:
                  (context) => AlertDialog(
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [Text('Your file has been saved.')],
                    ),
                  ),
            );
          });
        });
      }
    }

    newFn() {
      FileWrapper.instance
          .getSaveLocationFn(
            suggestedName: filepath,
            acceptedTypeGroups: [
              XTypeGroup(label: 'JKnit Document', extensions: ['.jmd']),
            ],
          )
          .then((result) {
            if (result != null) {
              setState(() {
                filepath = result.path;
                controller.text = defaultText;
              });
            }
          });
    }

    openFn() {
      FileWrapper.instance
          .openFileFn(
            acceptedTypeGroups: [
              XTypeGroup(label: 'JKnit Document', extensions: ['.jmd']),
            ],
          )
          .then((result) {
            if (result != null) {
              setState(() {
                filepath = result.path;
                result.readAsString().then((str) {
                  setState(() {
                    controller.text = str;
                  });
                });
              });
            }
          });
    }

    exportFn() {
      // Save file
      if (controller.text.isNotEmpty) {
        File(filepath).writeAsString(controller.text).then((_) {
          showDialog(
            context: context,
            builder: (context) => Export(filepath: filepath),
          );
        });
      }
    }

    helpFn() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HelpPage()),
      );
    }

    final result = MenuBar(
      children: [
        // File
        SubmenuButton(
          key: ValueKey('editor.menubar.file'),
          menuChildren: [
            // File -> Save
            MenuItemButton(
              key: ValueKey('editor.menubar.file.save'),
              onPressed: saveFn,
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyS,
                control: true,
              ),
              child: const MenuAcceleratorLabel('&Save'),
            ),
            // File -> Export
            MenuItemButton(
              key: ValueKey('editor.menubar.file.export'),
              onPressed: exportFn,
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyE,
                control: true,
              ),
              child: const MenuAcceleratorLabel('&Export'),
            ),
            // File -> Open
            MenuItemButton(
              key: ValueKey('editor.menubar.file.open'),
              onPressed: openFn,
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyO,
                control: true,
              ),
              child: const MenuAcceleratorLabel('&Open'),
            ),
            // File -> Open Recent
            SubmenuButton(
              key: ValueKey('editor.menubar.file.open_recent'),
              menuChildren: List<Widget>.generate(recent.length, (i) {
                return MenuItemButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditorPage(filepath: recent[i]),
                      ),
                    );
                  },
                  child: MenuAcceleratorLabel(recent[i]),
                );
              }),
              child: const MenuAcceleratorLabel('Open Recent'),
            ),
            // File -> New
            MenuItemButton(
              key: ValueKey('editor.menubar.file.new'),
              onPressed: newFn,
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyN,
                control: true,
              ),
              child: const MenuAcceleratorLabel('&New'),
            ),
          ],
          child: const MenuAcceleratorLabel('&File'),
        ),
        // Help
        SubmenuButton(
          key: ValueKey('editor.menubar.help'),
          menuChildren: [
            MenuItemButton(
              key: ValueKey('editor.menubar.help.help'),
              onPressed: helpFn,
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyH,
                control: true,
              ),
              child: const MenuAcceleratorLabel('Go to "&help"'),
            ),
          ],
          child: const MenuAcceleratorLabel('&Help'),
        ),
        // Options
        SubmenuButton(
          key: ValueKey('editor.menubar.options'),
          menuChildren: [
            MenuItemButton(
              key: ValueKey('editor.menubar.options.options'),
              onPressed: optionsFn,
              shortcut: const SingleActivator(
                LogicalKeyboardKey.keyP,
                control: true,
              ),
              child: const MenuAcceleratorLabel('Go to "O&ptions"'),
            ),
          ],
          child: const MenuAcceleratorLabel('O&ptions'),
        ),
      ],
    );

    var shortcuts = <ShortcutActivator, Intent>{};

    shortcuts[SingleActivator(
      LogicalKeyboardKey.keyP,
      control: true,
    )] = VoidCallbackIntent(optionsFn);
    shortcuts[SingleActivator(
      LogicalKeyboardKey.keyE,
      control: true,
    )] = VoidCallbackIntent(exportFn);
    shortcuts[SingleActivator(
      LogicalKeyboardKey.keyO,
      control: true,
    )] = VoidCallbackIntent(openFn);
    shortcuts[SingleActivator(
      LogicalKeyboardKey.keyN,
      control: true,
    )] = VoidCallbackIntent(newFn);
    shortcuts[SingleActivator(
      LogicalKeyboardKey.keyH,
      control: true,
    )] = VoidCallbackIntent(helpFn);
    shortcuts[SingleActivator(
      LogicalKeyboardKey.keyS,
      control: true,
    )] = VoidCallbackIntent(saveFn);

    ShortcutRegistry.of(context).addAll(shortcuts);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [Expanded(child: result)],
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [Expanded(child: editor)],
          ),
        ),
      ],
    );
  }
}
