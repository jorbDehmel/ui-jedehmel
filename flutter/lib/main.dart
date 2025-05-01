import 'package:flutter/material.dart';
import 'package:jknit_gui/screens/editor.dart';

void main() {
  runApp(const JKnitGUIApp());
}

class JKnitGUIApp extends StatelessWidget {
  const JKnitGUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JKnit Editor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) => EditorPage(filepath: null);
}
