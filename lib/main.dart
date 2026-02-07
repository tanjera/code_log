import 'dart:core';
import 'package:flutter/material.dart';

import 'views/page_main.dart';

const String appTitle = "Code Blue Log";

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue),
      ),
      home: const PageMain(title: appTitle),
    );
  }
}