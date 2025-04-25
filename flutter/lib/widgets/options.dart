import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

openOptions(context) {
  SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: <String>{
        'warnings_to_errors', // bool
        'enable_log', // bool
        'enable_timer', // bool
        'markdown_or_latex', // string ('markdown' or 'latex')
        'force_fancy', // bool
        'settings_files', // List of filepath strings
      },
    ),
  ).then((value) {
    showDialog(context: context, builder: (context) => Options(prefs: value));
  });
}

class Options extends StatefulWidget {
  const Options({super.key, required this.prefs});
  final SharedPreferencesWithCache prefs;

  @override
  OptionsState createState() => OptionsState(prefs: prefs);
}

class OptionsState extends State<Options> {
  OptionsState({required this.prefs});

  final SharedPreferencesWithCache prefs;

  @override
  Widget build(BuildContext context) {
    // Set default values
    if (!prefs.containsKey('warnings_to_errors')) {
      prefs.setBool('warnings_to_errors', false);
    }
    if (!prefs.containsKey('enable_log')) {
      prefs.setBool('enable_log', false);
    }
    if (!prefs.containsKey('enable_timer')) {
      prefs.setBool('enable_timer', false);
    }
    if (!prefs.containsKey('markdown_or_latex')) {
      prefs.setString('markdown_or_latex', 'markdown');
    }
    if (!prefs.containsKey('force_fancy')) {
      prefs.setBool('force_fancy', false);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Options"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Treat all Warnings as Errors'),
              Switch(
                key: ValueKey('options.warnings_to_errors'),
                value: prefs.getBool('warnings_to_errors')!,
                onChanged: (value) {
                  setState(() {
                    prefs.setBool('warnings_to_errors', value);
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enable Log'),
              Switch(
                key: ValueKey('options.enable_log'),
                value: prefs.getBool('enable_log')!,
                onChanged: (value) {
                  setState(() {
                    prefs.setBool('enable_log', value);
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enable Timer'),
              Switch(
                key: ValueKey('options.enable_timer'),
                value: prefs.getBool('enable_timer')!,
                onChanged: (value) {
                  setState(() {
                    prefs.setBool('enable_timer', value);
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Force Fancy Typesetting'),
              Switch(
                key: ValueKey('options.force_fancy'),
                value: prefs.getBool('force_fancy')!,
                onChanged: (value) {
                  setState(() {
                    prefs.setBool('force_fancy', value);
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Output File Type'),
              DropdownMenu<String>(
                key: ValueKey('options.markdown_or_latex'),
                dropdownMenuEntries: [
                  DropdownMenuEntry(value: 'markdown', label: 'MarkDown (.md)'),
                  DropdownMenuEntry(value: 'latex', label: 'LaTeX (.tex)'),
                ],
                initialSelection: prefs.getString('markdown_or_latex')!,
                onSelected: (value) {
                  setState(() {
                    prefs.setString('markdown_or_latex', value!);
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
