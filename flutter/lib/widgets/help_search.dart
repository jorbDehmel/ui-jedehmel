import 'package:flutter/material.dart';
import 'package:jknit_gui/screens/help.dart';

// Maps help screen names to their texts
const Map<String, String> screens = {
  "About":
      "This project was created as a learning exercise for UI design at "
      "Colorado Mesa University in Spring 2025 by Jordan Dehmel. This section "
      "details the motivations for (1) the JKnit tool itself and (2) the JKnit "
      "editor."
      "\n\n1. JKnit\n\n"
      "JKnit and the JMD file format are FOSS tools created as a lightweight "
      "alternative to R Markdown (RMD). Both JMD and RMD are supersets of the "
      "'Markdown' (MD) typesetting language, commonly used for code "
      "documentation. Both languages aim to be human-readable and minimally "
      "differ from Markdown while targetting 'knitted' documents with running "
      "code. Unlike Jupyter Notebooks, JMD code cells are always run in a "
      "consistant order: The goal is a document that can be physically "
      "printed, rather than a read-time interactive one."
      "\n\n2. JKnit Editor\n\n"
      "The JKnit command line tool for Linux predates this graphial interface "
      "by several years. However, the 'intuitive, low-overhead' goals of JMD "
      "are precluded by the counterintuitivity of the Linux command line. "
      "Therefore, this GUI aims to allow non-CS-students to interact with "
      "the tool.",
  "Export Settings":
      "This section details the available export options. These can be found "
      "in 'Options' from the main or export screens. They detail how the "
      "command-line interface is to be called, and therefore how the output "
      "document will be formatted."
      "\n\ntimer: "
      "If enabled, displays the time taken by the export process. This feature "
      "is currently unsupported."
      "\n\nlog: "
      "If enabled, displays any log messages reported by the knitter. This "
      "feature is currently unsupported."
      "\n\nwarnings to errors: "
      "If enabled, turns all warnings into errors."
      "\n\nmarkdown or latex: "
      "If Markdown is selected, the output file will be a Markdown document. "
      "Any code chunk output will be placed in its appropriate place. If LaTeX "
      "is selected instead, the output will be a '.tex' file which can later "
      "be compiled into a '.pdf'."
      "\n\nforce fancy: "
      "This option only applies in LaTeX mode. If it is disabled, the output "
      "'.tex' file wil try to look as much like the output of R Markdown as "
      "possible. If enabled, it will look like a (more professional) "
      "traditional LaTeX-prepared document.",
  "Markdown Syntax":
      "Markdown syntax help can be found here: "
      "https://www.markdownguide.org/cheat-sheet/\n\n"
      "And J-Markdown syntax help can be found here: "
      "https://github.com/jorbDehmel/jknit/blob/master/README.md",
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
