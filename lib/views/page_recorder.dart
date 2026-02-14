import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'dialog_code_end.dart';

import 'page_drugs.dart';
import 'page_events.dart';
import 'page_procedures.dart';
import 'page_rhythms.dart';

import '../classes/settings.dart';
import '../classes/log.dart';
import '../classes/log.entry.dart';
import '../classes/utility.dart';

class PageRecorder extends StatefulWidget {
  final Settings settings;
  final String title;

  const PageRecorder({super.key, required this.title, required this.settings});

  @override
  State<PageRecorder> createState() => PageRecorderState();
}

class PageRecorderState extends State<PageRecorder> {
  Log log = Log();

  late Timer _timerUI;

  final _playerMetronome = AudioPlayer();
  late Timer _timerMetronome;
  late AudioSource? _audioMetronome;
  bool _runMetronome = false;
  late int _runMetronomeRate;

  final Stopwatch _swCode = Stopwatch();
  String _btnCode = "Start Code";
  String _txtCode = "--:--";

  final Stopwatch _swCPR = Stopwatch();
  String _btnCPR = "Start CPR";
  String _txtCPR = "--:--";

  final Stopwatch _swShock = Stopwatch();
  String _txtShock = "--:--";
  int _cntShock = 0;
  
  final Stopwatch _swEpi = Stopwatch();
  String _txtEpi = "--:--";
  int _cntEpi = 0;

  final TextEditingController _tecIdentifier = TextEditingController();

  @override
  void initState() {
    super.initState();

    _timerUI = Timer.periodic(const Duration(seconds: 1), (_) {
      updateUI();
    });

    _runMetronomeRate = widget.settings.metronomeRate;
    double dblRate = (60000 / _runMetronomeRate);
    int intRate = dblRate.toInt();

    _timerMetronome = Timer.periodic(Duration(milliseconds: intRate), (_) {
      _playMetronome();
    });
  }
  
  void endCode () {
    // Follow metronomeAutoRun
    if (widget.settings.metronomeAutoRun) {
      _runMetronome = false;
    }

    // Close out and reset the log
    log.add(Entry(type: EntryType.event, description: "Code ended"));
    log = Log();

    // Reset the identifier field
    _tecIdentifier.text = "";

    // Reset the stopwatches
    _swCode.stop();
    _swCode.reset();
    _swCPR.stop();
    _swCPR.reset();
    _swShock.stop();
    _swShock.reset();
    _swEpi.stop();
    _swEpi.reset();

    _txtCode = "--:--";
    _txtCPR = "--:--";
    _txtShock = "--:--";
    _txtEpi = "--:--";

    // Reset the counters
    _cntShock = 0;
    _cntEpi = 0;

    updateUI();
  }

  void _pressedMetronome() {
    _runMetronome = !_runMetronome;

    updateUI();
  }

  Future<void> _setMetronome(int rate) async {
    _runMetronomeRate = rate;
    double dblRate = (60000 / _runMetronomeRate);
    int intRate = dblRate.toInt();

    if (_timerMetronome.isActive) {
      _timerMetronome.cancel();
    }

    _timerMetronome = Timer.periodic(Duration(milliseconds: intRate), (_) {
      _playMetronome();
    });
  }

  void _playMetronome() async {
    if (_runMetronomeRate != widget.settings.metronomeRate) {
      _setMetronome(widget.settings.metronomeRate);
    }

    if (_runMetronome) {
      if (_playerMetronome.audioSource == null) {
        _playerMetronome.setAudioSource(AudioSource.asset("assets/audio/click_1.wav"));
        // Don't play the audio on the same iteration as setting the audio or there will be an init delay...
      } else {
        _playerMetronome.seek(Duration(seconds: 0));
        _playerMetronome.play();
      }
      }
  }

  void _pressedCode() {
    if (!_swCode.isRunning) {
      _swCode.start();

      if (widget.settings.metronomeAutoRun) {
        _runMetronome = true;
      }

      log.add(Entry(type: EntryType.event, description: "Code started"));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogEndCode(this);
        },
      );
    }

    updateUI();
  }

  void _pressedCPR() {
    if (!_swCode.isRunning) {
      _pressedCode();
    }

    if (!_swCPR.isRunning) {
      _swCPR.start();

      log.add(Entry(type: EntryType.cpr, description: "CPR started"));
    } else {
      _swCPR.stop();
      _swCPR.reset();

      log.add(Entry(type: EntryType.cpr, description: "CPR paused"));
    }

    updateUI();
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

    _cntShock += 1;
    log.add(Entry(type: EntryType.shock, description: "Shock delivered"));

    updateUI();
  }

  void pressedEpi() {
    if (!_swCode.isRunning) {
      _pressedCode();
    }

    if (!_swEpi.isRunning) {
      _swEpi.start();
    } else {
      _swEpi.reset();
    }

    _cntEpi += 1;
    log.add(Entry(type: EntryType.drug, description: "Epinephrine administered"));

    updateUI();
  }

  void updateUI() {
    setState(() {
      _txtCode = formatTimer(_swCode.isRunning, _swCode.elapsedMilliseconds ~/ 1000);
      _txtCPR = formatTimer(_swCPR.isRunning, _swCPR.elapsedMilliseconds ~/ 1000);
      _txtShock = formatTimer(_swShock.isRunning, _swShock.elapsedMilliseconds ~/ 1000);
      _txtEpi = formatTimer(_swEpi.isRunning, _swEpi.elapsedMilliseconds ~/ 1000);

      _btnCode = !_swCode.isRunning ? "Start Code" : "End Code";
      _btnCPR = !_swCPR.isRunning ? "Start CPR" : "Pause CPR";
    });
  }

  @override
  void dispose() {
    _timerUI.cancel();
    _timerMetronome.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            Align(
              alignment: .centerLeft,
              child:Text(widget.title)
            )
          ]
        ),
          actions:
            <Widget> [
              IconButton(
                icon: _runMetronome ? Icon(Icons.volume_up_outlined) : Icon(Icons.volume_off_outlined),
                tooltip: 'Metronome',
                onPressed: () {
                  _pressedMetronome();

                  ScaffoldMessenger.of( context,
                  ).showSnackBar(SnackBar(content: Text("Metronome turned ${_runMetronome ? "on" : "off"}",
                    textAlign: TextAlign.center,)));
                },
              ),
              IconButton(
              icon: const Icon(Icons.save_outlined),
              tooltip: 'Save Log',
              onPressed: () {
                log.write();

                ScaffoldMessenger.of( context,
                  ).showSnackBar(const SnackBar(content: Text('Event log written to local storage.',
                textAlign: TextAlign.center,)));
                },
              ),
          ]
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .start,
          children: [
            TextField(
              controller: _tecIdentifier,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: InputBorder.none,
                hintText: 'Code Identifier (e.g. Location)',
              ),
              onChanged: (t) {
                log.identifier = t;
              },
            ),
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
                    Padding(padding: EdgeInsets.only(left: 5),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                        onPressed: _pressedCode,
                        child: Text(_btnCode,
                            style: TextStyle(fontSize: 24)),
                        )
                      )
                    ],
                  ),

                  TableRow(   // CPR
                    children: [
                      Center(
                        child: Text(_txtCPR,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      Padding(padding: EdgeInsets.only(left: 5),
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: _pressedCPR,
                          child: Text(_btnCPR,
                              style: TextStyle(fontSize: 24))
                        )
                      )
                    ],
                  ),

                  TableRow(   // Defibrillation
                    children: [
                      Stack(
                        alignment: AlignmentGeometry.center,
                        children: [
                          Text(_txtShock,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                          Container(
                            alignment: Alignment.centerRight,
                              child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.red.shade100,
                              child: Text("$_cntShock", style: TextStyle(fontSize: 14)
                              ),
                            )
                          )
                        ]
                      ),
                      Padding(padding: EdgeInsets.only(left: 5),
                          child: FilledButton(
                              style: FilledButton.styleFrom(backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                              onPressed: _pressedShock,
                              child: Text("Defibrillation",
                                  style: TextStyle(fontSize: 24))
                          )
                      )
                    ],
                  ),

                  TableRow(   // Epinephrine
                    children: [
                      Stack(
                          alignment: AlignmentGeometry.center,
                          children: [
                            Text(_txtEpi,
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Container(
                                alignment: Alignment.centerRight,
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Colors.brown.shade100,
                                  child: Text("$_cntEpi", style: TextStyle(fontSize: 14)
                                  ),
                                )
                            )
                          ]
                      ),
                      Padding(padding: EdgeInsets.only(left: 5),
                          child: FilledButton(
                              style: FilledButton.styleFrom(backgroundColor: Colors.brown.shade400,
                                  shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                              onPressed: pressedEpi,
                              child: Text("Epinephrine",
                                  style: TextStyle(fontSize: 24))
                          )
                      )
                    ],
                  ),

                  TableRow(   // Drugs & Rhythms
                    children: [
                      Padding(padding: EdgeInsets.only(right: 5),
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.pink,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (context) => PageDrugs(this)
                                )
                            );
                          },
                          child: Text("Drugs",
                              style: TextStyle(fontSize: 24))
                        )
                      ),
                      Padding(padding: EdgeInsets.only(left: 5),
                          child: FilledButton(
                              style: FilledButton.styleFrom(backgroundColor: Colors.red.shade900,
                                  shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (context) => PageRhythms(this)
                                    )
                                );
                              },
                              child: Text("Rhythms",
                                  style: TextStyle(fontSize: 24))
                          )
                      ),
                    ],
                  ),

                  TableRow(   // Procedures & Events
                    children: [
                      Padding(padding: EdgeInsets.only(right: 5),
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.orange.shade900,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (context) => PageProcedures(this)
                                )
                            );
                          },
                          child: Text("Procedures",
                              style: TextStyle(fontSize: 24))
                        )
                      ),
                      Padding(padding: EdgeInsets.only(left: 5),
                        child: FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Colors.purple,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                    builder: (context) => PageEvents(this)
                                )
                            );
                          },
                          child: Text("Events",
                              style: TextStyle(fontSize: 24))
                        )
                      ),
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
                    children: log.entries.map((item) =>
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