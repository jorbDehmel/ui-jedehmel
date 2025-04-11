import 'package:flutter/material.dart';

class HelpSearch extends StatelessWidget {
  final String query;
  const HelpSearch({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(query),
      ),
      body: ListView(
        children: [const Text('Help search results would go here')],
      ),
    );
  }
}
