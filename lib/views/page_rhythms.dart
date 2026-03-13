import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dialog_delete_list_item.dart';
import 'dialog_edit_rhythm.dart';
import 'page_recorder.dart';

import '../models/rhythm.dart';

import '../classes/log.entry.dart';
import '../classes/rhythms.dart';
import '../classes/settings.dart';

class PageRhythms extends StatefulWidget {
  final PageRecorderState prs;
  final Rhythms rhythms = Rhythms();

  PageRhythms(this.prs, {super.key});

  @override
  State<PageRhythms> createState() => PageRhythmsState();
}

class PageRhythmsState extends State<PageRhythms> {

  Future<void> _addRhythm () async {
    Rhythm r = Rhythm("", Colors.transparent);

    final edit = await showDialog<Rhythm>(
      context: context,
      builder: (BuildContext context) {
        return DialogEditRhythm(r);
      },
    );

    if (edit == null) {
      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Canceled addition. No changes made.",
        textAlign: TextAlign.center,)));

    } else if (edit.name.trim() != "") {
      Settings settings = widget.prs.widget.settings;

      setState(() {
        r.name = edit.name;
        r.color = edit.color;
        r.favorite = edit.favorite;

        settings.listRhythms.add(r);
        settings.listRhythms = Rhythms().sort(settings.listRhythms, settings.arrangeListFavorite);
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

  Future<void> _editRhythm (Rhythm r) async {
    final edit = await showDialog<Rhythm>(
      context: context,
      builder: (BuildContext context) {
        return DialogEditRhythm(r.clone());
      },
    );

    if (edit == null) {
      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Canceled edit. No changes made.",
        textAlign: TextAlign.center,)));

    } else if (edit.name.trim() != "") {
      Settings settings = widget.prs.widget.settings;

      setState(() {
        r.name = edit.name;
        r.color = edit.color;
        r.favorite = edit.favorite;
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
  
  Future<void> _deleteRhythm (Rhythm r) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DialogDeleteListItem();
      },
    );

    if (delete != null && delete == true) {
      final Settings settings = widget.prs.widget.settings;

      setState(() {
        settings.listRhythms.remove(r);
        settings.save();
      });

      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Rhythm deleted",
        textAlign: TextAlign.center,)));
    }
  }

  Future<void> _toggleFavorite (Rhythm i) async {
    Settings settings = widget.prs.widget.settings;

    setState(() {
      i.favorite = !i.favorite;

      settings.listRhythms = Rhythms().sort(settings.listRhythms, settings.arrangeListFavorite);
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

  @override
  Widget build(BuildContext context) {
    final PageRecorderState prs = widget.prs;
    final Settings settings = prs.widget.settings;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Cardiac Rhythms"),
          actions: <Widget> [
            IconButton(
                icon: Icon(_iconAdd()),
                tooltip: 'Add Item',
                onPressed: () => _addRhythm()
            )
          ]
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: .start,
            children: settings.listRhythms.map((i) =>
                SlidableAutoCloseBehavior(
                    closeWhenTapped: true,
                    child: Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: .25,
                      children: [
                        SlidableAction(
                            onPressed: (c) => _editRhythm(i),
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                            icon: _iconEdit()
                        ),
                        SlidableAction(
                            onPressed: (c) => _deleteRhythm(i),
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            backgroundColor: Colors.red,
                            icon: _iconDelete()
                        ),
                      ],
                    ),

                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: .25,
                      children: [
                        SlidableAction(
                            onPressed: (c) => _editRhythm(i),
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                            icon: _iconEdit()
                        ),
                        SlidableAction(
                            onPressed: (c) => _deleteRhythm(i),
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
                                      onTap: () =>
                                          Slidable
                                              .of(ltContext)
                                              ?.openStartActionPane(),
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Icon(Icons.more_vert,
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
                              prs.log.add(Entry(
                                  type: EntryType.rhythm,
                                  description: "Cardiac rhythm: ${i.name}"));
                              prs.updateUI();
                              Navigator.pop(context);
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