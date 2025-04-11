import 'package:flutter/material.dart';
import '../widgets/help_search.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Help"),
        actions: [
          SearchBar(
            key: ValueKey('help.search'),
            hintText: 'Search for help...',
            onSubmitted: (query) {
              showDialog(
                context: context,
                builder: (context) => HelpSearch(query: query),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Column(
            children: [
              const Text('Help topic 1'),
              const Text('Help topic 2'),
              const Text('Help topic 3'),
              const Text('Help topic 4'),
            ],
          ),
          VerticalDivider(),
          const Text('Help text goes over here'),
        ],
      ),
    );
  }
}
