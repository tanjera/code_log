import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dialog_delete_list_item.dart';
import 'dialog_edit_drug.dart';
import 'page_recorder.dart';

import '../models/drug.dart';

import '../classes/drugs.dart';
import '../classes/log.entry.dart';
import '../classes/settings.dart';

class PageDrugs extends StatefulWidget {
  final PageRecorderState prs;
  final Drugs drugs = Drugs();

  PageDrugs(this.prs, {super.key});

  @override
  State<PageDrugs> createState() => PageDrugsState();
}

class PageDrugsState extends State<PageDrugs> {

  Future<void> _addDrug () async {
    Drug d = Drug("", "", Colors.transparent);

    final edit = await showDialog<Drug>(
      context: context,
      builder: (BuildContext context) {
        return DialogEditDrug(d);
      },
    );

    if (edit == null) {
      ScaffoldMessenger.of( context,
      ).showSnackBar(SnackBar(content: Text("Canceled addition. No changes made.",
        textAlign: TextAlign.center,)));

    } else if (edit.name.trim() != "") {
      Settings settings = widget.prs.widget.settings;

      setState(() {
        d.name = edit.name;
        d.route = edit.route;
        d.color = edit.color;
        d.favorite = edit.favorite;

        settings.listDrugs.add(d);
        settings.listDrugs = Drugs().sort(settings.listDrugs, settings.arrangeListFavorite);
      });

      settings.save();
      ScaffoldMessenger.of(context,
      ).showSnackBar(SnackBar(content: Text("Item added successfully.",
        textAlign: TextAlign.center,)));

    } else {
      ScaffoldMessenger.of(context,
      ).showSnackBar(SnackBar(content: Text("Invalid entry. Unable to add item.",
        textAlign: TextAlign.center,)));
    }
  }

  Future<void> _editDrug (Drug d) async {
    final edit = await showDialog<Drug>(
      context: context,
      builder: (BuildContext context) {
        return DialogEditDrug(d.clone());
      },
    );

    if (edit == null) {
      ScaffoldMessenger.of(context,
      ).showSnackBar(SnackBar(content: Text("Canceled edit. No changes made.",
        textAlign: TextAlign.center,)));

    } else if (edit.name.trim() != "") {
      Settings settings = widget.prs.widget.settings;

      setState(() {
        d.name = edit.name;
        d.route = edit.route;
        d.color = edit.color;
        d.favorite = edit.favorite;
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

  Future<void> _deleteDrug (Drug d) async {
    final delete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DialogDeleteListItem();
      },
    );

    if (delete != null && delete == true) {
      final Settings settings = widget.prs.widget.settings;

      setState(() {
        settings.listDrugs.remove(d);
        settings.save();
      });

      ScaffoldMessenger.of(context,
      ).showSnackBar(SnackBar(content: Text("Drug deleted",
        textAlign: TextAlign.center,)));
    }
  }
  
  Future<void> _toggleFavorite (Drug i) async {
    Settings settings = widget.prs.widget.settings;

    setState(() {
      i.favorite = !i.favorite;
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
        title: Text("Drugs"),
          actions: <Widget> [
            IconButton(
                icon: Icon(_iconAdd()),
                tooltip: 'Add Item',
                onPressed: () => _addDrug()
            )
          ]
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: .start,
                children: settings.listDrugs.map((i) =>

                    Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: .25,
                          children: [
                            SlidableAction(
                                onPressed: (c) => _editDrug(i),
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                icon: _iconEdit()
                            ),
                            SlidableAction(
                                onPressed: (c) => _deleteDrug(i),
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor: Colors.red,
                                icon: _iconDelete()
                            ),
                          ],
                        ),

                        child:ListTile(
                          title: Text(i.name),
                          subtitle: i.route != null && i.route != "" ? Text(i.route!) : null,

                          leading: IconButton(
                              onPressed: () => _toggleFavorite(i),
                              icon: i.favorite
                                  ? Icon(Icons.star_rounded,
                                  color: Theme.of(context).brightness == .light
                                      ? Colors.yellow.shade800
                                      : Colors.yellow
                              )
                                  : Icon(Icons.star_outline_rounded,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(50)
                              )
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
                            if (i.name == "Epinephrine") {
                              prs.pressedEpi();
                            } else {
                              if (i.route == null || i.route!.trim() == "") {
                                prs.log.add(Entry(type: EntryType.drug,
                                    description: "${i.name} administered"));
                              } else {
                                prs.log.add(Entry(type: EntryType.drug,
                                    description: "${i.name} (${i
                                        .route}) administered"));
                              }
                            }
                            Navigator.pop(context);
                          },
                        )
                    )
                ).toList()
            )
          )
      )
    );
  }
}
