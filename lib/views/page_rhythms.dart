import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  bool _showHidden = false;

  void _toggleShowHidden() {
    setState(() {
      _showHidden = !_showHidden;
    });
  }

  void _hideEntry (Rhythm r) {
    final Settings settings = widget.prs.widget.settings;

    setState(() {
      if (settings.hiddenRhythms.any((hr) => hr.name == r.name)) {
        settings.hiddenRhythms.removeWhere((hr) => hr.name == r.name);
      } else {
        settings.hiddenRhythms.add(r);
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
        title: Text("Cardiac Rhythms"),
          actions:
          <Widget> [
            IconButton(
              icon: Icon(_showHidden ? _iconShow() : _iconHide()),
              tooltip: 'Show hidden items',
              onPressed: () { settings.hiddenRhythms.isEmpty ? null : _toggleShowHidden(); },
            ),
          ]
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: .start,
            children: widget.rhythms.list
                .where((r) => _showHidden
                ? true
                : !settings.hiddenRhythms.any((hr) => hr.name == r.name))
                .map((r) =>

                Slidable(
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: .1,
                      children: [
                        SlidableAction(
                            onPressed: (c) => _hideEntry(r),
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            backgroundColor: Colors.red,
                            icon: settings.hiddenRhythms.any((hr) => hr.name == r.name)
                                ? _iconShow() : _iconHide()
                        ),
                      ],
                    ),

                    child: ListTile(
                      title: Text(r.name,
                          style: TextStyle(
                              color: settings.hiddenRhythms.any((hr) => hr.name == r.name)
                                  ? Theme.of(context).colorScheme.onSurface.withAlpha(100)
                                  : Theme.of(context).colorScheme.onSurface
                          )
                      ),
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