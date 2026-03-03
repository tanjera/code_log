import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'dialog_code_end.dart';

import 'page_drugs.dart';
import 'page_events.dart';
import 'page_procedures.dart';
import 'page_rhythms.dart';

import '../main.dart';
import '../classes/settings.dart';
import '../classes/log.dart';
import '../classes/log.entry.dart';
import '../classes/utility.dart';

class PageRecorder extends StatefulWidget {
  final VoidCallback updateLogs;
  final Settings settings;
  final String title;

  const PageRecorder({super.key, required this.title, required this.settings, required this.updateLogs});

  @override
  State<PageRecorder> createState() => PageRecorderState();
}

class PageRecorderState extends State<PageRecorder> {
  Log log = Log();

  late Timer _timerUI;
  
  final _playerMetronome = AudioPlayer();
  late Timer _timerMetronome;
  bool _runMetronome = false;
  late int _runMetronomeRate;

  final Stopwatch _swCode = Stopwatch();
  String _btnCode = "Start Code";
  String _txtCode = "--:--";

  final _playerCPRAlarm = AudioPlayer();
  final Stopwatch _swCPR = Stopwatch();
  String _btnCPR = "Start CPR";
  String _txtCPR = "--:--";
  late Color _colorCPR = Colors.black;
  int _cntCPR = 0;

  final Stopwatch _swShock = Stopwatch();
  String _txtShock = "--:--";
  int _cntShock = 0;
  
  final Stopwatch _swEpi = Stopwatch();
  String _txtEpi = "--:--";
  int _cntEpi = 0;

  final TextEditingController _tecIdentifier = TextEditingController();
  final ScrollController _scEventLog = ScrollController();

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

    log.scroll = scrollEventLog;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _colorCPR = Theme.of(context).colorScheme.onSurface;
  }

  void endCode () {
    // Follow metronomeAutoRun
    if (widget.settings.metronomeAutoRun) {
      _runMetronome = false;
    }

    // Close out and reset the log
    log.add(Entry(type: EntryType.event, description: "Code ended"));

    log = Log();
    log.scroll = scrollEventLog;

    // Tell PageMain to update PageLogs
    widget.updateLogs();

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
    _cntCPR = 0;
    _cntShock = 0;
    _cntEpi = 0;

    updateUI();
  }

  void _pressedTheme() {
    ThemeProvider tp = Provider.of<ThemeProvider>(context, listen: false);
    tp.toggleTheme();

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
        await _playerMetronome.setAudioSource(AudioSource.asset("assets/audio/click_1.wav"));
        // Don't play the audio on the same iteration as setting the audio or there will be an init delay...
      } else {
        await _playerMetronome.seek(Duration(seconds: 0));
        await _playerMetronome.setVolume(1.0);
        await _playerMetronome.play();
      }
      }
  }
  
  void _playCPRAlarm() async {
    if (_playerCPRAlarm.audioSource == null) {
      await _playerCPRAlarm.setAudioSource(
          AudioSource.asset("assets/audio/alarm_1.wav"));
    }

    await Future.delayed(const Duration(milliseconds: 500), () async {
      await _playerCPRAlarm.seek(Duration(seconds: 0));
      await _playerCPRAlarm.setVolume(1.0);
      await _playerCPRAlarm.play();
    });
  }

  void _pressedCode() {
    if (!_swCode.isRunning) {
      _swCode.start();

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
      _cntCPR += 1;

      // Start the CPR metronome when CPR starts
      if (widget.settings.metronomeAutoRun) {
        _runMetronome = true;
      }

      log.add(Entry(type: EntryType.cpr, description: "CPR started (cycle #$_cntCPR)"));
    } else {
      _swCPR.stop();
      _swCPR.reset();

      // Stop the CPR metronome when CPR pauses
      if (widget.settings.metronomeAutoRun) {
        _runMetronome = false;
      }

      if (_playerCPRAlarm.playing) {
        _playerCPRAlarm.stop();
      }

      log.add(Entry(type: EntryType.cpr, description: "CPR paused (cycle #$_cntCPR)"));
    }

    // Whenever the timer starts/stops, it should be reset to black
    _colorCPR = Theme.of(context).colorScheme.onSurface;;

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
    log.add(Entry(type: EntryType.shock, description: "Defibrillation delivered (#$_cntShock)"));

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
    log.add(Entry(type: EntryType.drug, description: "Epinephrine administered (dose #$_cntEpi)"));

    updateUI();
  }

  void _deleteEntry(Entry e) {
    setState(() {
      if (widget.settings.eventDeleteMode == .redact) {
        e.redacted = !e.redacted;
      } else if (widget.settings.eventDeleteMode == .delete) {
        log.entries.remove(e);
      }

      log.save();
    });
  }

  void updateUI() {
    setState(() {
      _txtCode = formatTimer(_swCode.isRunning, _swCode.elapsedMilliseconds ~/ 1000);
      _txtCPR = formatTimer(_swCPR.isRunning, _swCPR.elapsedMilliseconds ~/ 1000);
      _txtShock = formatTimer(_swShock.isRunning, _swShock.elapsedMilliseconds ~/ 1000);
      _txtEpi = formatTimer(_swEpi.isRunning, _swEpi.elapsedMilliseconds ~/ 1000);

      if (_swCPR.isRunning && widget.settings.alertCPRTimer != .none) {
        int sec = _swCPR.elapsedMilliseconds ~/ 1000;

        // Change _colorCPR to flash CPR timer if 1:50 - 2:00 (yellow) and > 2:00 (red)
        if (widget.settings.alertCPRTimer == .both || widget.settings.alertCPRTimer == .visual) {
          if (sec >= 105 && sec < 120) {
            _colorCPR = (sec % 2 == 0) ? Colors.yellow : Theme.of(context).colorScheme.onSurface;
          } else if (sec >= 120) {
            _colorCPR = (sec % 2 == 0) ? Colors.red : Theme.of(context).colorScheme.onSurface;
          }
        } else {
          _colorCPR = Theme.of(context).colorScheme.onSurface;;
        }

        // Audible CPR alarm
        if (widget.settings.alertCPRTimer == .both || widget.settings.alertCPRTimer == .audio) {
          if (sec == 120) {
            _playCPRAlarm();
          }
        }
      }

      _btnCode = !_swCode.isRunning ? "Start Code" : "End Code";
      _btnCPR = !_swCPR.isRunning ? "Start CPR" : "Pause CPR";
    });
  }

  void scrollEventLog() async {
    setState(() {
      _scEventLog.animateTo(
        _scEventLog.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    });
  }

  IconData _iconDelete () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.delete,
      "macos" => CupertinoIcons.delete,
      _ => Icons.delete_outlined
    };
  }

  IconData _iconTheme (ThemeMode t) {
    switch (t) {
      case .dark:
        return switch (Platform.operatingSystem) {
          "ios" => CupertinoIcons.brightness_solid,
          "macos" => CupertinoIcons.brightness_solid,
          _ => Icons.brightness_6
        };

      case .light:
      default:
        return switch (Platform.operatingSystem) {
          "ios" => CupertinoIcons.brightness,
          "macos" => CupertinoIcons.brightness,
          _ => Icons.brightness_6_outlined
        };
    }

  }

  IconData _iconMetronome (bool running) {
    if (running) {
      return switch (Platform.operatingSystem) {
        "ios" => CupertinoIcons.speaker_3,
        "macos" => CupertinoIcons.speaker_3,
        _ => Icons.volume_up_outlined
      };
    } else {
      return switch (Platform.operatingSystem) {
        "ios" => CupertinoIcons.speaker_slash,
        "macos" => CupertinoIcons.speaker_slash,
        _ => Icons.volume_off_outlined
      };
    }
  }

  IconData _iconSave () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.archivebox,
      "macos" => CupertinoIcons.archivebox,
      _ => Icons.save_outlined
    };
  }

  @override
  void dispose() {
    _timerUI.cancel();
    _timerMetronome.cancel();

    _tecIdentifier.dispose();
    _scEventLog.dispose();

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
                icon: Icon(_iconTheme(Provider.of<ThemeProvider>(context).themeMode)),
                tooltip: 'Color theme',
                onPressed: () {
                  _pressedTheme();
                },
              ),
              
              IconButton(
                icon: Icon(_iconMetronome(_runMetronome)),
                tooltip: 'Metronome',
                onPressed: () {
                  _pressedMetronome();

                  ScaffoldMessenger.of( context,
                  ).showSnackBar(SnackBar(content: Text("Metronome turned ${_runMetronome ? "on" : "off"}",
                    textAlign: TextAlign.center,)));
                },
              ),
              
              IconButton(
              icon: Icon(_iconSave()),
              tooltip: 'Save Log',
              onPressed: () {
                log.save();

                ScaffoldMessenger.of( context,
                  ).showSnackBar(const SnackBar(content: Text('Event log written to local storage.',
                textAlign: TextAlign.center,)));
                },
              ),
          ]
      ),
      body: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .stretch,
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
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(_txtCode,
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)
                          )
                        )
                      ),
                    Padding(padding: EdgeInsets.only(left: 5),
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                        onPressed: _pressedCode,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(_btnCode,
                            style: TextStyle(fontSize: 24)),
                        )
                        )
                      )
                    ],
                  ),

                  TableRow(   // CPR
                    children: [
                      Stack(
                          alignment: AlignmentGeometry.center,
                          children: [
                            FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(_txtCPR,
                                    style: TextStyle(
                                        color: _colorCPR,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold)
                                )
                            ),
                            Container(
                                alignment: Alignment.centerRight,
                                child: CircleAvatar(
                                  radius: 15,
                                  child: Text("$_cntCPR", style: TextStyle(fontSize: 14)
                                  ),
                                )
                            )
                          ]
                      ),
                      Padding(padding: EdgeInsets.only(left: 5),
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                          onPressed: _pressedCPR,
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(_btnCPR,
                                style: TextStyle(fontSize: 24))
                          )
                        )
                      )
                    ],
                  ),

                  TableRow(   // Defibrillation
                    children: [
                      Stack(
                        alignment: AlignmentGeometry.center,
                        children: [
                          FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(_txtShock,
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                              )
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                              child: CircleAvatar(
                              radius: 15,
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
                              child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("Defibrillation",
                                    style: TextStyle(fontSize: 24))
                              )
                          )
                      )
                    ],
                  ),

                  TableRow(   // Epinephrine
                    children: [
                      Stack(
                          alignment: AlignmentGeometry.center,
                          children: [
                            FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(_txtEpi,
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                                )
                            ),
                            Container(
                                alignment: Alignment.centerRight,
                                child: CircleAvatar(
                                  radius: 15,
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
                              child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("Epinephrine",
                                    style: TextStyle(fontSize: 24))
                              )
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
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text("Drugs",
                                style: TextStyle(fontSize: 24))
                          )
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
                              child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text("Rhythms",
                                    style: TextStyle(fontSize: 24))
                              )
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
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text("Procedures",
                                style: TextStyle(fontSize: 24))
                          )
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
                          child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text("Events",
                                style: TextStyle(fontSize: 24))
                          )
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

            Center(child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child:Text("Event Log",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
              ),
            ),

            Expanded( child:ListView(
              scrollDirection: .vertical,
              controller: _scEventLog,
              children: log.entries.map((item) =>
                  Slidable(
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: .1,
                        children: [
                          SlidableAction(
                            onPressed: (c) => _deleteEntry(item),
                            backgroundColor: item.redacted ? Colors.green : Colors.red,
                            foregroundColor: Colors.white,
                            icon: _iconDelete()
                          ),
                        ],
                      ),

                      child: Row(children:[ Padding(
                        padding: widget.settings.eventLogCompact
                            ? .symmetric(horizontal: 10, vertical: 5)
                            : .symmetric(horizontal: 10, vertical: 10),
                        child: Text("${item['occurred']}:\t${item['description']}",
                          style: TextStyle(
                                fontSize: 14,
                                color: item.redacted ? Colors.grey : Colors.black,
                                decoration: item.redacted ? .lineThrough : null ),
                        ),
                      )]
                      )
                  )
              ).toList()
              )
            )
          ],
        ),

    );
  }
}