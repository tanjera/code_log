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

  final List<Event> _events = [];

  final Stopwatch _swCode = Stopwatch();
  String _btnCode = "Start Code";
  String _txtCode = "";

  final Stopwatch _swCPR = Stopwatch();
  String _btnCPR = "Start CPR";
  String _txtCPR = "";

  final Stopwatch _swShock = Stopwatch();
  String _txtShock = "";


  final Stopwatch _swEpi = Stopwatch();
  String _txtEpi = "";


  void _pressedCode() {
    if (!_swCode.isRunning) {
      _swCode.start();
      _events.add(Event(type: EventType.Event, description: "Code started"));
    }

    _updateUI();
  }

  void _pressedCPR() {
    if (!_swCode.isRunning) {
      _pressedCode();
    }

    if (!_swCPR.isRunning) {
      _swCPR.start();

      _events.add(Event(type: EventType.CPR, description: "CPR started"));
    } else {
      _swCPR.stop();
      _swCPR.reset();

      _events.add(Event(type: EventType.CPR, description: "CPR paused"));
    }

    _updateUI();
  }

  void _pressedShock() {
    if (!_swCode.isRunning) {
      _pressedCode();
    }

    if (!_swShock.isRunning) {
      _swShock.start();
    } else {
      _swShock.reset();
    }

    _events.add(Event(type: EventType.Shock, description: "Shock delivered"));

    _updateUI();
  }

  void _pressedEpi() {
    if (!_swCode.isRunning) {
      _pressedCode();
    }

    if (!_swEpi.isRunning) {
      _swEpi.start();
    } else {
      _swEpi.reset();
    }

    _events.add(Event(type: EventType.Drug, description: "Epinephrine administered"));

    _updateUI();
  }
  void _updateUI() {
    setState(() {
      _txtCode = formatTimer(_swCode.isRunning, _swCode.elapsedMilliseconds ~/ 1000);
      _txtCPR = formatTimer(_swCPR.isRunning, _swCPR.elapsedMilliseconds ~/ 1000);
      _txtShock = formatTimer(_swShock.isRunning, _swShock.elapsedMilliseconds ~/ 1000);
      _txtEpi = formatTimer(_swEpi.isRunning, _swEpi.elapsedMilliseconds ~/ 1000);

      _btnCode = !_swCode.isRunning ? "Start Code" : "Stop Code";
      _btnCPR = !_swCPR.isRunning ? "Start CPR" : "Pause CPR";
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
            Padding (
              padding: EdgeInsetsGeometry.symmetric(vertical: 0, horizontal: 10),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                children: [
                  TableRow(   // Overall code time
                    children: [
                      Center(
                        child: Text(_txtCode,
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      ),
                      FilledButton(
                        style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                        onPressed: _pressedCode,
                        child: Text(_btnCode,
                            style: TextStyle(fontSize: 28)),
                      )
                    ],
                  ),

                  TableRow(   // CPR
                    children: [
                      Center(
                        child: Text(_txtCPR,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.blueGrey),
                          onPressed: _pressedCPR,
                          child: Text(_btnCPR,
                              style: TextStyle(fontSize: 24))
                      )
                    ],
                  ),

                  TableRow(   // Defibrillation
                    children: [
                      Center(
                        child: Text(_txtShock,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.red),
                          onPressed: _pressedShock,
                          child: Text("Shock",
                              style: TextStyle(fontSize: 24))
                      )
                    ],
                  ),

                  TableRow(   // Epinephrine
                    children: [
                      Center(
                        child: Text(_txtEpi,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.brown),
                          onPressed: _pressedEpi,
                          child: Text("Epinephrine",
                              style: TextStyle(fontSize: 24))
                      )
                    ],
                  ),
                ]
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10),
              child: Divider(height: 1.0)
            ),

            Text("Event Log",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
              ),
            )
          ],
        ),
      )
    );
  }
}
