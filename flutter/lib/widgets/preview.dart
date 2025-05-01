/*
A markdown preview screen
*/

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class Preview extends StatelessWidget {
  const Preview({super.key, required this.filepath});

  // A normal markdown file to render
  final String filepath;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: Markdown(data: File(filepath).readAsStringSync()),
  );
}
