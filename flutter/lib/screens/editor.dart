import "package:flutter/material.dart";
import "../widgets/export.dart";

class EditorPage extends StatefulWidget {
  const EditorPage({super.key, required this.filepath});
  final String filepath;

  @override
  State<StatefulWidget> createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("JKnit Project Editor"),
      ),
      body: Row(
        children: [
          Column(
            children: [
              const Text("Files go over here"),
              const Text("Files go over here"),
              const Text("Files go over here"),
              const Text("Files go over here"),
            ],
          ),
          VerticalDivider(),
          const Text("Currently open file goes here"),
        ],
      ),
      floatingActionButton: ElevatedButton(
        key: ValueKey('editor.export'),
        onPressed: () {
          showDialog(context: context, builder: (context) => Export());
        },
        child: const Text('Export'),
      ),
    );
  }
}
