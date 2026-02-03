import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';

import 'event.dart';
import 'utility.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Log',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue),
      ),
      home: const Page(title: 'Code Log'),
    );
  }
}

class Page extends StatefulWidget {
  const Page({super.key, required this.title});

  final String title;

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late Timer _timerUI;

  List<Event> _events = [];

  final Stopwatch _swCode = Stopwatch();
  String _btnCode = "";
  String _txtCode = "";

  final Stopwatch _swShock = Stopwatch();
  String _btnShock = "";
  String _txtShock = "";


  void _pressedCode() {
    if (!_swCode.isRunning) {
      _swCode.start();
      _events.add(Event(type: EventType.Event, description: "Code started"));
    }

    _updateUI();
  }

  void _pressedShock() {
    if (!_swShock.isRunning) {
      _swShock.start();
      _events.add(Event(type: EventType.Shock, description: "Shock delivered"));
    }

    _updateUI();
  }
  
  void _updateUI() {
    setState(() {
      _txtCode = formatTime(_swCode.elapsedMilliseconds ~/ 1000);

      if (!_swCode.isRunning) {
        _btnCode = "Start";
      } else if (_swCode.isRunning){
        _btnCode = "Stop";
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _timerUI = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateUI();
    });
  }

  @override
  void dispose() {
    _timerUI.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .start,
          children: [

            Row(
              mainAxisAlignment: .center,
              spacing: 15,
              children: [
                Text(_txtCode,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: _pressedCode,
                  child: Text(_btnCode,
                    style: TextStyle(fontSize: 28)),
                )
              ],
            ),

            Row(
              mainAxisAlignment: .center,
              spacing: 15,
              children: [
                Text(_txtShock,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: _pressedShock,
                    child: Text(_btnShock,
                        style: TextStyle(fontSize: 28))
                )
              ],
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Divider(height: 1.0)
            ),

            Text("Event Log:",
              style: TextStyle(fontSize: 18)),

            Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
              },
              children: _events.map((item) =>
                TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(item['occurred'])
                    ),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(item['description']),
                    )
                  ]
                )
              ).toList(),
            ),
          ],
        ),
      )
    );
  }
}
