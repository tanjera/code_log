import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dialog_delete_list_item.dart';
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

  Future<void> _confirmDeleteProcedure (Procedure p) async {
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
        title: Text("Procedures"),
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
                          extentRatio: .1,
                          children: [
                            SlidableAction(
                                onPressed: (c) => _confirmDeleteProcedure(p),
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor: Colors.red,
                                icon: _iconDelete()
                            ),
                          ],
                        ),

                        child: ListTile(
                          title: Text(p.title),
                          subtitle: p.subtitle != null ? Text(p.subtitle!) : null,
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
