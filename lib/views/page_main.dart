import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../classes/log.dart';
import '../classes/logs.dart';
import '../classes/settings.dart';
import '../classes/utility.dart';

import 'page_logs.dart';
import 'page_recorder.dart';
import 'page_settings.dart';

import '../main.dart';

class PageMain extends StatefulWidget {
  final String title;
  final Logs logs = Logs();
  final Settings settings = Settings();

  PageMain({super.key, required this.title});
  @override
  State<PageMain> createState() => PageMainState();
}

class PageMainState extends State<PageMain> {
  late final VoidCallback _vcbUpdateLogs = _updateLogs;

  late Logs _logs = Logs();
  late Settings _settings;

  int _selectedIndex = 0;

  late final List<StatefulWidget> _widgetOptions = <StatefulWidget>[
    PageRecorder(title: appTitle, settings: _settings, updateLogs: _vcbUpdateLogs),
    PageLogs(logs: _logs, settings: _settings),
    PageSettings(settings: _settings),
  ];

  @override
  void initState() {
    super.initState();

    _logs = widget.logs;
    _settings = widget.settings;

    loadLogs();
    loadSettings();
  }

  Future<void> loadLogs() async {
    widget.logs.list = [];

    final files = await localLogs();
    files.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    for (int i = 0; i < files.length; i++) {
      Log? l = Log();
      l = await l.load(files[i]);
      if (l != null) {
        widget.logs.list.add(l);
      }
    }

    setState(() {
      _widgetOptions[1] = PageLogs(logs: _logs, settings: _settings,);
    });
  }

  Future<void> loadSettings() async {
    await widget.settings.load();

    setState(() {
      _widgetOptions[2] = PageSettings(settings: _settings);
    });
  }

  void _updateLogs() {
    loadLogs();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  IconData _iconRecorder () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.alarm,
      "macos" => CupertinoIcons.alarm,
      _ => Icons.alarm
    };
  }

  IconData _iconLogs () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.doc_text_search,
      "macos" => CupertinoIcons.doc_text_search,
      _ => Icons.assignment_outlined
    };
  }

  IconData _iconSettings () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.gear,
      "macos" => CupertinoIcons.gear,
      _ => Icons.settings_outlined
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(_iconRecorder()), label: 'Recorder'),
          BottomNavigationBarItem(icon: Icon(_iconLogs()), label: 'Logs'),
          BottomNavigationBarItem(icon: Icon(_iconSettings()), label: 'Settings'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}