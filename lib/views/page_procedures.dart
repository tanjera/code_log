import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  bool _showHidden = false;

  void _toggleShowHidden() {
    setState(() {
      _showHidden = !_showHidden;
    });
  }

  void _hideEntry (Procedure p) {
    final Settings settings = widget.prs.widget.settings;

    setState(() {
      if (settings.hiddenProcedures.any((hp) =>
          hp.title == p.title && hp.subtitle == p.subtitle && hp.log == p.log)) {
        settings.hiddenProcedures.removeWhere((hp) =>
          hp.title == p.title && hp.subtitle == p.subtitle && hp.log == p.log);
      } else {
        settings.hiddenProcedures.add(p);
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
        title: Text("Procedures"),
        actions:
          <Widget> [
            IconButton(
              icon: Icon(_showHidden ? _iconShow() : _iconHide()),
              tooltip: 'Show hidden items',
              onPressed: () { settings.hiddenProcedures.isEmpty ? null : _toggleShowHidden(); },
            ),
          ]
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: .start,
                children: widget.procedures.list
                    .where((p) => _showHidden
                    ? true
                    : !settings.hiddenProcedures.any((hp) =>
                        hp.title == p.title && hp.subtitle == p.subtitle && hp.log == p.log))
                    .map((p) =>

                    Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: .1,
                          children: [
                            SlidableAction(
                                onPressed: (c) => _hideEntry(p),
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor: Colors.red,
                                icon: settings.hiddenProcedures.any((hp) =>
                                    hp.title == p.title && hp.subtitle == p.subtitle && hp.log == p.log)
                                    ? _iconShow() : _iconHide()
                            ),
                          ],
                        ),

                        child: ListTile(
                          title: Text(p.title,
                            style: TextStyle(
                              color: settings.hiddenProcedures.any((hp) =>
                                  hp.title == p.title && hp.subtitle == p.subtitle && hp.log == p.log)
                                  ? Theme.of(context).colorScheme.onSurface.withAlpha(100)
                                  : Theme.of(context).colorScheme.onSurface
                            )
                          ),
                          subtitle: p.subtitle != null
                              ? Text(p.subtitle!,
                                  style: TextStyle(
                                      color: settings.hiddenProcedures.any((hp) =>
                                      hp.title == p.title && hp.subtitle == p.subtitle && hp.log == p.log)
                                          ? Theme.of(context).colorScheme.onSurface.withAlpha(100)
                                          : Theme.of(context).colorScheme.onSurface
                                  )
                              )
                              : null,
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
