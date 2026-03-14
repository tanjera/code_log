import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dialog_event_free_text.dart';
import 'dialog_event_vital_signs.dart';

import 'dialog_delete_list_item.dart';
import 'dialog_edit_event.dart';
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

  Future<void> _vitalSigns(BuildContext context) async {
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

  Future<void> _freeText(BuildContext context) async {
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

  Future<void> _addEvent () async {
    Event e = Event("", "", Colors.transparent);

    final edit = await showDialog<Event>(
      context: context,
      builder: (BuildContext context) {
        return DialogEditEvent(e);
      },
    );


    if (edit == null) {
      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Canceled addition. No changes made.",
        textAlign: TextAlign.center,)));

    } else if (edit.name.trim() != "") {
      Settings settings = widget.prs.widget.settings;

      setState(() {
        e.name = edit.name;
        e.description = edit.description.trim() != ""
            ? edit.description
            : edit.name.toSentenceCase();
        e.color = edit.color;
        e.favorite = edit.favorite;

        settings.listEvents.add(e);
        settings.listEvents = Events().sort(settings.listEvents, settings.arrangeListFavorite);
      });

      settings.save();

      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Item added successfully.",
        textAlign: TextAlign.center,)));

    } else {
      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Invalid entry. Unable to add item.",
        textAlign: TextAlign.center,)));
    }
  }


  Future<void> _editEvent (Event e) async {
    final edit = await showDialog<Event>(
      context: context,
      builder: (BuildContext context) {
        return DialogEditEvent(e.clone());
      },
    );


    if (edit == null) {
      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Canceled edit. No changes made.",
        textAlign: TextAlign.center,)));

    } else if (edit.name.trim() != "") {
      Settings settings = widget.prs.widget.settings;

      setState(() {
        e.name = edit.name;
        e.description = edit.description.trim() != ""
          ? edit.description
          : edit.name.toSentenceCase();
        e.color = edit.color;
        e.favorite = edit.favorite;
      });

      settings.save();

      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Item edited successfully.",
        textAlign: TextAlign.center,)));

    } else {
      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Invalid entry. Unable to edit item.",
        textAlign: TextAlign.center,)));
    }
  }
  
  Future<void> _deleteEvent (Event e) async {
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

  Future<void> _toggleFavorite (Event i) async {
    Settings settings = widget.prs.widget.settings;

    setState(() {
      i.favorite = !i.favorite;

      settings.listEvents = Events().sort(settings.listEvents, settings.arrangeListFavorite);
    });

    settings.save();
  }

  IconData _iconAdd () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.text_badge_plus,
      "macos" => CupertinoIcons.text_badge_plus,
      _ => Icons.playlist_add
    };
  }

  IconData _iconEdit () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.pencil_ellipsis_rectangle,
      "macos" => CupertinoIcons.pencil_ellipsis_rectangle,
      _ => Icons.edit_note
    };
  }

  IconData _iconDelete () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.text_badge_minus,
      "macos" => CupertinoIcons.text_badge_minus,
      _ => Icons.playlist_remove
    };
  }

  IconData _iconOpenSlider () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.chevron_right,
      "macos" => CupertinoIcons.chevron_right,
      _ => Icons.menu_open_rounded
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
          actions: <Widget> [
            IconButton(
                icon: Icon(_iconAdd()),
                tooltip: 'Add Item',
                onPressed: () => _addEvent()
            )
          ]
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: .start,
              children: settings.listEvents.map((i) =>

                  SlidableAutoCloseBehavior(
                      closeWhenTapped: true,
                      child: Slidable(
                      startActionPane:  // Don't allow "Free Text" & "Vital Signs" to be editable
                      (i.name == "Other (Free Text)" || i.name == "Vital Signs")
                          ? null
                          : ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: .25,
                        children: [
                          SlidableAction(
                              onPressed: (c) => _editEvent(i),
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                              icon: _iconEdit()
                          ),
                          SlidableAction(
                              onPressed: (c) => _deleteEvent(i),
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: Colors.red,
                              icon: _iconDelete()
                          ),
                        ],
                      ),

                      endActionPane:  // Don't allow "Free Text" & "Vital Signs" to be editable
                      (i.name == "Other (Free Text)" || i.name == "Vital Signs")
                          ? null
                          : ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: .25,
                        children: [
                          SlidableAction(
                              onPressed: (c) => _editEvent(i),
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                              icon: _iconEdit()
                          ),
                          SlidableAction(
                              onPressed: (c) => _deleteEvent(i),
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: Colors.red,
                              icon: _iconDelete()
                          ),
                        ],
                      ),

                      child: Builder(
                          builder: (ltContext) {
                            return ListTile(
                              title: Text(i.name),

                              leading: Row(
                                  mainAxisSize: .min,
                                  children: [
                                    InkWell(
                                        onTap:() => Slidable.of(ltContext)?.openStartActionPane(),
                                        borderRadius: BorderRadius.circular(50.0),
                                        child: Icon(_iconOpenSlider(),
                                            color: Theme
                                                .of(context)
                                                .colorScheme
                                                .onSurfaceVariant
                                                .withAlpha(50))
                                    ),
                                    IconButton(
                                          onPressed: () => _toggleFavorite(i),
                                          icon: i.favorite
                                              ? Icon(Icons.star_rounded,
                                              color: Theme
                                                  .of(context)
                                                  .brightness == .light
                                                  ? Colors.yellow.shade600
                                                  : Colors.yellow
                                          )
                                              : Icon(Icons.star_outline_rounded,
                                              color: Theme
                                                  .of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant
                                                  .withAlpha(50)
                                          )
                                      ),
                                  ]
                                ),

                              trailing: i.color == null
                                  ? null
                                  : Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: i.color ?? Colors.transparent
                                ),
                              ),

                              onTap: () {
                                if (i.name == "Other (Free Text)") {
                                  _freeText(context);
                                } else if (i.name == "Vital Signs") {
                                  _vitalSigns(context);
                                } else {
                                  prs.log.add(Entry(
                                      type: EntryType.event,
                                      description: i.description ?? ""));
                                  prs.updateUI();
                                  Navigator.pop(context);
                                }
                              },
                            );
                          })
                  ))
            ).toList(),
            )
        )
      )
    );
  }
}