import 'dart:io';

import 'package:codebluelog/views/dialog_edit_drug.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dialog_delete_list_item.dart';
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

  Future<void> _editDrug (Drug d) async {
    final edit = await showDialog<Drug>(
      context: context,
      builder: (BuildContext context) {
        return DialogEditDrug(d);
      },
    );

    if (edit != null) {
      Settings settings = widget.prs.widget.settings;

      setState(() {
        d.name = edit.name;
        d.route = edit.route;
      });

      settings.save();
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

  IconData _iconAdd () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.text_badge_plus,
      "macos" => CupertinoIcons.text_badge_plus,
      _ => Icons.playlist_add_check
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
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: .start,
                children: settings.listDrugs.map((d) =>

                    Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: .25,
                          children: [
                            SlidableAction(
                                onPressed: (c) => _editDrug(d),
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
                                icon: _iconEdit()
                            ),
                            SlidableAction(
                                onPressed: (c) => _deleteDrug(d),
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor: Colors.red,
                                icon: _iconDelete()
                            ),
                          ],
                        ),

                        child:ListTile(
                          title: Text(d.name),
                          subtitle: d.route != null ? Text(d.route!) : null,
                          trailing: d.color != null ? CircleAvatar(backgroundColor: d.color) : null,
                          onTap: () {
                            if (d.name == "Epinephrine") {
                              prs.pressedEpi();
                            } else {
                              if (d.route == null) {
                                prs.log.add(Entry(type: EntryType.drug,
                                    description: "${d.name} administered"));
                              } else {
                                prs.log.add(Entry(type: EntryType.drug,
                                    description: "${d.name} (${d
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
