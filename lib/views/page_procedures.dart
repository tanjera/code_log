import 'dart:io';

import 'package:change_case/change_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dialog_delete_list_item.dart';
import 'dialog_edit_procedure.dart';
import 'page_recorder.dart';

import '../models/procedure.dart';

import '../classes/log.entry.dart';
import '../classes/procedures.dart';
import '../classes/settings.dart';

class PageProcedures extends StatefulWidget {
  final PageRecorderState prs;
  final Procedures procedures = Procedures();

  PageProcedures(this.prs, {super.key});

  @override
  State<PageProcedures> createState() => PageProceduresState();
}

class PageProceduresState extends State<PageProcedures> {

  Future<void> _addProcedure () async {
    Procedure p = Procedure("", "", "", Colors.transparent);

    final edit = await showDialog<Procedure>(
      context: context,
      builder: (BuildContext context) {
        return DialogEditProcedure(p);
      },
    );

    if (edit == null) {
      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Canceled addition. No changes made.",
        textAlign: TextAlign.center,)));

    } else if (edit.title.trim() != "") {
      Settings settings = widget.prs.widget.settings;

      setState(() {
        p.title = edit.title;
        p.subtitle = edit.subtitle;
        p.log = edit.log.trim() != ""
            ? edit.log
            : edit.title.toSentenceCase();
        p.color = edit.color;
        p.favorite = edit.favorite;

        settings.listProcedures.add(p);
        settings.listProcedures = Procedures().sort(settings.listProcedures);
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

  Future<void> _editProcedure (Procedure p) async {
    final edit = await showDialog<Procedure>(
      context: context,
      builder: (BuildContext context) {
        return DialogEditProcedure(p.clone());
      },
    );

    if (edit == null) {
      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Canceled edit. No changes made.",
        textAlign: TextAlign.center,)));

    } else if (edit.title.trim() != "") {
      Settings settings = widget.prs.widget.settings;

      setState(() {
        p.title = edit.title;
        p.subtitle = edit.subtitle;
        p.log = edit.log.trim() != ""
          ? edit.log
          : edit.title.toSentenceCase();
        p.color = edit.color;
        p.favorite = edit.favorite;
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
  
  Future<void> _deleteProcedure (Procedure p) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DialogDeleteListItem();
      },
    );

    if (delete != null && delete == true) {
      final Settings settings = widget.prs.widget.settings;

      setState(() {
        settings.listProcedures.remove(p);
        settings.save();
      });

      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Procedure deleted",
        textAlign: TextAlign.center,)));
    }
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
        title: Text("Procedures"),
          actions: <Widget> [
            IconButton(
                icon: Icon(_iconAdd()),
                tooltip: 'Add Item',
                onPressed: () => _addProcedure()
            )
          ]
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: .start,
                children: settings.listProcedures.map((p) =>

                    Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: .25,
                          children: [
                            SlidableAction(
                                onPressed: (c) => _editProcedure(p),
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                icon: _iconEdit()
                            ),
                            SlidableAction(
                                onPressed: (c) => _deleteProcedure(p),
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor: Colors.red,
                                icon: _iconDelete()
                            ),
                          ],
                        ),

                        /* For implementing favorite items... uncomment when ready
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: .12,
                          children: [
                            SlidableAction(
                                onPressed: (c) => setState(() {
                                  d.favorite = !d.favorite;
                                }),
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor: Colors.yellow.shade800,
                                icon: d.favorite ? Icons.star_rounded : Icons.star_outline_rounded
                            ),
                          ],
                        ),
                        */

                        child: ListTile(
                          title: Text(p.title),
                          subtitle: p.subtitle != null && p.subtitle != "" ? Text(p.subtitle!) : null,
                          trailing: p.color != null ? CircleAvatar(backgroundColor: p.color) : null,
                          onTap: () {
                            prs.log.add(Entry(
                              type: EntryType.procedure,
                                      description: p.log));
                            prs.updateUI();
                            Navigator.pop(context);
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
