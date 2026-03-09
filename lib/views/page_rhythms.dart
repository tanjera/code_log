import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'dialog_delete_list_item.dart';
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

  Future<void> _confirmDeleteRhythm (Rhythm r) async {
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
        title: Text("Cardiac Rhythms"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: .start,
            children: settings.listRhythms.map((r) =>
                Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: .1,
                      children: [
                        SlidableAction(
                            onPressed: (c) => _confirmDeleteRhythm(r),
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            backgroundColor: Colors.red,
                            icon: _iconDelete()
                        ),
                      ],
                    ),

                    child: ListTile(
                      title: Text(r.name),
                      trailing: r.color != null ? CircleAvatar(backgroundColor: r.color) : null,
                      onTap: () {
                        prs.log.add(Entry(
                            type: EntryType.rhythm,
                            description: "Cardiac rhythm: ${r.name}"));
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