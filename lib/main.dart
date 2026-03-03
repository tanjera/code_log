import 'dart:core';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/page_main.dart';

const String appTitle = "Code Blue Log";

void main() {
  runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const App(),
      ));
}

class ThemeProvider with ChangeNotifier {
  // Default to the system's default, but change once Settings are loaded if different
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setTheme(ThemeMode t) {
    _themeMode = t;
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: appTitle,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      home: PageMain(title: appTitle),
    );
  }
}