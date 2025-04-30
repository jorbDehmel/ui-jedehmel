import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import '../screens/editor.dart';

class OpenProject extends StatefulWidget {
  const OpenProject({super.key});

  @override
  State<StatefulWidget> createState() => OpenProjectState();
}

class OpenProjectState extends State<OpenProject> {
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
                key: ValueKey('open.select_file'),
                onPressed: () {
                  openFile().then((result) {
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
            key: ValueKey('open.editor'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditorPage(filepath: _filepath),
                ),
              );
            },
            child: const Text("Open"),
          ),
        ],
      ),
    );
  }
}
