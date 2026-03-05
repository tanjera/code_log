import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dialog_event_free_text.dart';
import 'dialog_event_vital_signs.dart';
import 'page_recorder.dart';

import '../models/event.dart';

import '../classes/log.entry.dart';
import '../classes/events.dart';
import '../classes/settings.dart';

class Note {
  String? text;

  Note();
}

class VitalSigns {
  int? hr;
  int? rr;
  int? spo2;
  int? sbp;
  int? dbp;
  int? etco2;
  double? t;

  VitalSigns();
}

class PageEvents extends StatefulWidget {
  final PageRecorderState prs;
  final Events events = Events();

  PageEvents(this.prs, {super.key});

  @override
  State<PageEvents> createState() => PageEventsState();
}

class PageEventsState extends State<PageEvents> {
  bool _showHidden = false;

  Future<void> _getVitals(BuildContext context) async {
    final vs = await showDialog<VitalSigns>(
      context: context,
      builder: (BuildContext context) {
        return DialogEventVitalSigns();
      },
    );

    if (vs != null) {
      String desc = "Vital signs:\n";

      if (vs.hr != null) {
        desc += "- Heart rate (HR): ${vs.hr}\n";
      }
      if (vs.sbp != null || vs.dbp != null) {
        desc += "- Blood pressure (BP): ${vs.sbp} / ${vs.dbp ?? 0}\n";
      }
      if (vs.rr != null) {
        desc += "- Respiratory rate (RR): ${vs.rr}\n";
      }
      if (vs.spo2 != null) {
        desc += "- Pulse oximetry (SpO2): ${vs.spo2}\n";
      }
      if (vs.etco2 != null) {
        desc += "- End-tidal Capnometry (ETCO2): ${vs.etco2}\n";
      }
      if (vs.t != null) {
        desc += "- Temperature (T): ${vs.t!.toStringAsFixed(1)}";
      }

      if (vs.hr != null || vs.sbp != null || vs.dbp != null || vs.rr != null
          || vs.spo2 != null || vs.etco2 != null || vs.t != null) {
        widget.prs.log.add(Entry(
            type: EntryType.event,
            description: desc.trim()
        ));
      }
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _getFreeText(BuildContext context) async {
    final note = await showDialog<Note>(
      context: context,
      builder: (BuildContext context) {
        return DialogEventFreeText();
      },
    );

    if (note != null && note.text != null) {
      String desc = "Free text note: ${note.text}";

      widget.prs.log.add(Entry(
          type: EntryType.event,
          description: desc.trim()
      ));
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  void _toggleShowHidden() {
    setState(() {
      _showHidden = !_showHidden;
    });
  }

  void _hideEntry (Event e) {
    final Settings settings = widget.prs.widget.settings;

    setState(() {
      if (settings.hiddenEvents.any((he) => he.name == e.name)) {
        settings.hiddenEvents.removeWhere((he) => he.name == e.name);
      } else {
        settings.hiddenEvents.add(e);
      }
    });

    settings.save();
  }

  IconData _iconHide () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.ellipsis_circle_fill,
      "macos" => CupertinoIcons.ellipsis_circle_fill,
      _ => Icons.playlist_remove
    };
  }

  IconData _iconShow () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.ellipsis_circle,
      "macos" => CupertinoIcons.ellipsis_circle,
      _ => Icons.playlist_add_check
    };
  }

  @override
  Widget build(BuildContext context) {
    final PageRecorderState prs = widget.prs;
    final Settings settings = prs.widget.settings;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Events"),
        actions:
          <Widget> [
            IconButton(
              icon: Icon(_showHidden ? _iconShow() : _iconHide()),
              tooltip: 'Show hidden items',
              onPressed: () { settings.hiddenEvents.isEmpty ? null : _toggleShowHidden(); },
            ),
          ]
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: .start,
              children: widget.events.list
                  .where((e) => _showHidden
                    ? true
                    : !settings.hiddenEvents.any((he) => he.name == e.name))
                  .map((e) =>

                  Slidable(
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: .1,
                        children: [
                          SlidableAction(
                              onPressed: (c) => _hideEntry(e),
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: Colors.red,
                              icon: settings.hiddenEvents.any((he) => he.name == e.name)
                                ? _iconShow() : _iconHide()
                          ),
                        ],
                      ),

                      child: ListTile(
                        title: Text(e.name,
                            style: TextStyle(
                                color: settings.hiddenEvents.any((he) => he.name == e.name)
                                    ? Theme.of(context).colorScheme.onSurface.withAlpha(100)
                                    : Theme.of(context).colorScheme.onSurface
                            )),
                        trailing: e.color != null ? CircleAvatar(backgroundColor: e.color) : null,
                        onTap: () {
                          if (e.name == "Other (Free Text)") {
                            _getFreeText(context);
                          } else if (e.name == "Vital Signs") {
                            _getVitals(context);
                          } else {
                            prs.log.add(Entry(
                                type: EntryType.event,
                                description: e.description));
                            prs.updateUI();
                            Navigator.pop(context);
                          }
                        },
                      )
                  )
            ).toList(),
            )
        )
      )
    );
  }
}