/*
Export widget for jknit. This allows options and places the actual system call.
*/

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:jknit_gui/widgets/options.dart';

class Export extends StatelessWidget {
  const Export({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Export Document"),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              key: ValueKey('export.options'),
              onPressed: () {
                openOptions(context);
              },
              child: const Text('Options'),
            ),
            ElevatedButton(
              key: ValueKey('export.export'),
              onPressed: () {
                // Prepare system call
                List<String> arguments = List<String>.empty(growable: true);

                // Place system call (BLOCKING)
                var result = Process.runSync('jknit', arguments);
                Navigator.pop(context);

                // Success case
                if (result.exitCode == 0) {
                  showDialog(
                    context: context,
                    builder:
                        (context) =>
                            const Text("Success! Your file has been exported."),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder:
                        (context) => Scaffold(
                          appBar: AppBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            title: Text("Export ERROR"),
                          ),
                          body: Text(
                            "${result.stderr}\n${result.stdout}\n\n${result.exitCode}",
                          ),
                        ),
                  );
                }
              },
              child: const Text("Export"),
            ),
          ],
        ),
      ),
    );
  }
}
