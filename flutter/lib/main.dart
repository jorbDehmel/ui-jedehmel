import 'package:flutter/material.dart';
import 'widgets/new.dart';
import 'widgets/open.dart';
import 'widgets/options.dart';
import 'screens/help.dart';

void main() {
  runApp(const JKnitGUIApp());
}

class JKnitGUIApp extends StatelessWidget {
  const JKnitGUIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'JKnit Editor'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              key: ValueKey('main.new'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => NewProject(),
                );
              },
              child: const Text('New'),
            ),
            ElevatedButton(
              key: ValueKey('main.open'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => OpenProject(),
                );
              },
              child: const Text('Open'),
            ),
            ElevatedButton(
              key: ValueKey('main.options'),
              onPressed: () {
                openOptions(context);
              },
              child: const Text('Options'),
            ),
            ElevatedButton(
              key: ValueKey('main.help'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HelpPage()),
                );
              },
              child: const Text('Help'),
            ),
          ],
        ),
      ),
    );
  }
}
