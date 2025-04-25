import 'package:flutter/material.dart';
import '../widgets/help_search.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key, this.screenToPullUp = "About"});
  final String screenToPullUp;

  @override
  State<HelpPage> createState() => HelpPageState(curScreen: screenToPullUp);
}

class HelpPageState extends State<HelpPage> {
  HelpPageState({required this.curScreen});
  String curScreen;

  @override
  Widget build(BuildContext context) {
    var lhs = <Widget>[];
    for (final key in screens.keys) {
      if (key == curScreen) {
        lhs.add(
          TextButton(
            child: Text(key, style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              setState(() {
                curScreen = key;
              });
            },
          ),
        );
      } else {
        lhs.add(
          TextButton(
            child: Text(key),
            onPressed: () {
              setState(() {
                curScreen = key;
              });
            },
          ),
        );
      }
    }

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
                builder: (context) => HelpSearch(query: RegExp(query)),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          Column(children: lhs),
          VerticalDivider(),
          Column(children: [Text(screens[curScreen]!)]),
        ],
      ),
    );
  }
}
