import 'package:flutter/material.dart';
import 'package:jknit_gui/screens/help.dart';

// Maps help screen names to their texts
const Map<String, String> screens = {
  "About": "About text goes here",
  "General": "General help goes here",
  "Export Settings": "Export setting details go here",
  "Licensing": "Copyright 2025, Jordan Dehmel, MIT license",
};

class HelpSearch extends StatelessWidget {
  final RegExp query;
  const HelpSearch({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    var resultLinks = <Widget>[];
    for (final key in screens.keys) {
      if (query.hasMatch(key) || query.hasMatch(screens[key]!)) {
        resultLinks.add(
          TextButton(
            child: Text(key),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HelpPage(screenToPullUp: key),
                ),
              );
            },
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(query.pattern),
      ),
      body: ListView(children: resultLinks),
    );
  }
}
