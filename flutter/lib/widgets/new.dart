import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import '../screens/editor.dart';

class NewProject extends StatefulWidget {
  const NewProject({super.key});

  @override
  State<StatefulWidget> createState() => NewProjectState();
}

class NewProjectState extends State<NewProject> {
  String _filepath = 'foo.jmd';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("New Project"),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              children: [
                Text(_filepath),
                ElevatedButton(
                  key: ValueKey('new.select_file'),
                  onPressed: () async {
                    setState(() async {
                      final FileSaveLocation? result = await getSaveLocation(
                        suggestedName: _filepath,
                      );
                      if (result != null) {
                        _filepath = result.path;
                      }
                    });
                  },
                  child: const Text('Select file'),
                ),
              ],
            ),
            ElevatedButton(
              key: ValueKey('new.editor'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditorPage(filepath: _filepath),
                  ),
                );
              },
              child: const Text("Create Project"),
            ),
          ],
        ),
      ),
    );
  }
}
