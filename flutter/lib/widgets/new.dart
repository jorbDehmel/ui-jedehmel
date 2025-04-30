import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import '../screens/editor.dart';

class NewProject extends StatefulWidget {
  const NewProject({super.key});

  @override
  State<StatefulWidget> createState() => NewProjectState();
}

class NewProjectState extends State<NewProject> {
  String _filepath = 'writeup.jmd';

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
              Text(_filepath, style: TextStyle(fontFamily: 'mono')),
              Spacer(),
              ElevatedButton(
                key: ValueKey('new.select_file'),
                onPressed: () {
                  getSaveLocation(suggestedName: _filepath).then((result) {
                    if (result != null) {
                      setState(() {
                        _filepath = result.path;
                      });
                    }
                  });
                },
                child: const Text('Browse'),
              ),
            ],
          ),
          Divider(),
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
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}
