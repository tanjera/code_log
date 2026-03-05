import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
  bool _showHidden = false;

  void _toggleShowHidden() {
    setState(() {
      _showHidden = !_showHidden;
    });
  }

  void _hideEntry (Drug d) {
    final Settings settings = widget.prs.widget.settings;

    setState(() {
      if (settings.hiddenDrugs.any((hd) => hd.name == d.name && hd.route == d.route)) {
        settings.hiddenDrugs.removeWhere((hd) => hd.name == d.name && hd.route == d.route);
      } else {
        settings.hiddenDrugs.add(d);
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
        title: Text("Drugs"),
          actions:
          <Widget> [
            IconButton(
              icon: Icon(_showHidden ? _iconShow() : _iconHide()),
              tooltip: 'Show hidden items',
              onPressed: () { settings.hiddenDrugs.isEmpty ? null : _toggleShowHidden(); },
            ),
          ]
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: .start,
                children: widget.drugs.list
                    .where((d) => _showHidden
                    ? true
                    : !settings.hiddenDrugs.any((hd) => hd.name == d.name && hd.route == d.route))
                    .map((d) =>

                    Slidable(
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          extentRatio: .1,
                          children: [
                            SlidableAction(
                                onPressed: (c) => _hideEntry(d),
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor: Colors.red,
                                icon: settings.hiddenDrugs.any((hd) => hd.name == d.name && hd.route == d.route)
                                    ? _iconShow() : _iconHide()
                            ),
                          ],
                        ),

                        child:ListTile(
                          title: Text(d.name,
                              style: TextStyle(
                                  color: settings.hiddenDrugs.any((hd) => hd.name == d.name && hd.route == d.route)
                                      ? Theme.of(context).colorScheme.onSurface.withAlpha(100)
                                      : Theme.of(context).colorScheme.onSurface
                              )),
                          subtitle: d.route != null
                              ? Text(d.route!,
                                  style: TextStyle(
                                      color: settings.hiddenDrugs.any((hd) => hd.name == d.name && hd.route == d.route)
                                          ? Theme.of(context).colorScheme.onSurface.withAlpha(100)
                                          : Theme.of(context).colorScheme.onSurface
                                  ))
                              : null,
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
