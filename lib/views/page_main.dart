import 'dart:core';
import 'package:codebluelog/classes/settings.dart';
import 'package:flutter/material.dart';

import 'page_logs.dart';
import 'page_recorder.dart';
import 'page_settings.dart';

import '../main.dart';

class PageMain extends StatefulWidget {
  PageMain({super.key, required this.title});

  final String title;
  final Settings settings = Settings();

  @override
  State<PageMain> createState() => PageMainState();
}

class PageMainState extends State<PageMain> {
  late Settings _settings;
  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions = <Widget>[
    PageRecorder(title: appTitle, settings: _settings),
    PageLogs(),
    PageSettings(settings: _settings),
  ];

  @override
  void initState() {
    super.initState();

    _settings = widget.settings;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Recorder'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), label: 'Logs'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}