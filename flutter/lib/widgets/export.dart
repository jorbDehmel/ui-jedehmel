/*
Export widget for jknit. This allows options and places the actual system call.
*/

import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:jknit_gui/widgets/options.dart';
import 'package:jknit_gui/widgets/preview.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SystemWrapper {
  ProcessResult Function(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Map<String, String>? environment,
    bool includeParentEnvironment,
    bool runInShell,
    Encoding? stdoutEncoding,
    Encoding? stderrEncoding,
  })
  systemCall = Process.runSync;
  static SystemWrapper instance = SystemWrapper();
}

class Export extends StatefulWidget {
  const Export({super.key, required this.filepath});

  final String filepath;

  @override
  State<StatefulWidget> createState() => ExportState(filepath: filepath);
}

class ExportState extends State<Export> {
  ExportState({required this.filepath}) {
    settings = SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{
          'warnings_to_errors', // bool
          'enable_log', // bool
          'enable_timer', // bool
          'markdown_or_latex', // string ('markdown' or 'latex')
          'force_fancy', // bool
          'settings_files', // List of filepath strings (not supported)
        },
      ),
    );
    targetFile = "$filepath.output";
    settings.then((resolved) {
      if (targetFile.startsWith("$filepath.")) {
        setState(() {
          if ((resolved.getString("markdown_or_latex") ?? "latex") == "latex") {
            targetFile = "$filepath.tex";
          } else {
            targetFile = "$filepath.md";
          }
        });
      }
    });
  }

  final String filepath;
  late String targetFile;
  late Future<SharedPreferencesWithCache> settings;

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
              Text(targetFile, style: TextStyle(fontFamily: 'mono')),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  getSaveLocation(
                    suggestedName: targetFile,
                    acceptedTypeGroups: [
                      XTypeGroup(label: "MarkDown", extensions: [".md"]),
                      XTypeGroup(label: "LaTeX", extensions: [".tex"]),
                    ],
                  ).then((result) {
                    if (result != null) {
                      setState(() {
                        targetFile = result.path;
                      });
                    }
                  });
                },
                child: const Text('Select Target'),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              ElevatedButton(
                key: ValueKey('export.options'),
                onPressed: () {
                  setState(() {
                    openOptionsScreen(context);
                  });
                },
                child: const Text('Options'),
              ),
              Spacer(),
              ElevatedButton(
                key: ValueKey('export.export'),
                onPressed: () {
                  settings.then((s) {
                    // Prepare system call
                    List<String> arguments = List<String>.empty(growable: true);

                    arguments.add(filepath);
                    arguments.add("-o");
                    arguments.add(targetFile);

                    if (s.getBool("warnings_to_errors") ?? false) {
                      arguments.add("-e");
                    }
                    if (s.getBool("enable_log") ?? false) {
                      arguments.add("-l");
                    }
                    if (s.getBool("enable_timer") ?? false) {
                      arguments.add("-t");
                    }

                    if ((s.getString("markdown_or_latex") ?? "latex") ==
                        "latex") {
                      if (s.getBool("force_fancy") ?? false) {
                        arguments.add("-xx");
                      } else {
                        arguments.add("-x");
                      }
                    }

                    // Place system call (BLOCKING)
                    var result = SystemWrapper.instance.systemCall(
                      'jknit',
                      arguments,
                    );
                    Navigator.pop(context);

                    // Success case
                    if (result.exitCode == 0) {
                      if ((s.getString("markdown_or_latex") ?? "latex") ==
                          "markdown") {
                        showDialog(
                          context: context,
                          builder:
                              (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AlertDialog(
                                    content: Center(
                                      child: Column(
                                        children: [
                                          Text(result.stdout),
                                          const Divider(),
                                          const Text(
                                            "Success! Your file has been exported.",
                                          ),
                                          const Divider(),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder:
                                                      (context) => Preview(
                                                        filepath: targetFile,
                                                      ),
                                                ),
                                              );
                                            },
                                            child: const Text("View"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder:
                              (context) => Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AlertDialog(
                                    content: Center(
                                      child: Column(
                                        children: [
                                          Text(result.stdout),
                                          const Divider(),
                                          const Text(
                                            "Success! Your file has been exported.",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder:
                            (context) => Scaffold(
                              appBar: AppBar(
                                backgroundColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.inversePrimary,
                                title: Text("Export ERROR"),
                              ),
                              body: Text(
                                "${result.stderr}\n${result.stdout}\n\n${result.exitCode}",
                              ),
                            ),
                      );
                    }
                  });
                },
                child: const Text("Export"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
