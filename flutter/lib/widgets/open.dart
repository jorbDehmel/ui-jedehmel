import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import '../screens/editor.dart';

class OpenProject extends StatefulWidget {
  const OpenProject({super.key});

  @override
  State<StatefulWidget> createState() => OpenProjectState();
}

class OpenProjectState extends State<OpenProject> {
  String _filepath = 'foo.jmd';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_filepath),
              ElevatedButton(
                key: ValueKey('open.select_file'),
                onPressed: () async {
                  setState(() async {
                    final result = await openFile();
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
            key: ValueKey('open.editor'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditorPage(filepath: 'foo.jmd'),
                ),
              );
            },
            child: const Text("Create Project"),
          ),
        ],
      ),
    );
  }
}
