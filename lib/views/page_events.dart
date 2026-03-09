import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dialog_event_free_text.dart';
import 'dialog_event_vital_signs.dart';

import 'dialog_delete_list_item.dart';
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

  Future<void> _confirmDeleteEvent (Event e) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DialogDeleteListItem();
      },
    );

    if (delete != null && delete == true) {
      final Settings settings = widget.prs.widget.settings;

      setState(() {
        settings.listEvents.remove(e);
        settings.save();
      });

      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Event deleted",
        textAlign: TextAlign.center,)));
    }
  }
  
  IconData _iconAdd () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.ellipsis_circle,
      "macos" => CupertinoIcons.ellipsis_circle,
      _ => Icons.playlist_add_check
    };
  }

  IconData _iconDelete () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.ellipsis_circle_fill,
      "macos" => CupertinoIcons.ellipsis_circle_fill,
      _ => Icons.playlist_remove
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
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: .start,
              children: settings.listEvents.map((e) =>

                  Slidable(
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: .1,
                        children: [
                          SlidableAction(
                              onPressed: (c) => _confirmDeleteEvent(e),
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: Colors.red,
                              icon: _iconDelete()
                          ),
                        ],
                      ),

                      child: ListTile(
                        title: Text(e.name),
                        trailing: e.color != null ? CircleAvatar(backgroundColor: e.color) : null,
                        onTap: () {
                          if (e.name == "Other (Free Text)") {
                            _getFreeText(context);
                          } else if (e.name == "Vital Signs") {
                            _getVitals(context);
                          } else {
                            prs.log.add(Entry(
                                type: EntryType.event,
                                description: e.description ?? ""));
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