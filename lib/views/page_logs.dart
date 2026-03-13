import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../classes/log.dart';
import '../classes/logs.dart';
import '../classes/settings.dart';
import '../classes/utility.dart';

import 'dialog_delete_log.dart';
import 'dialog_delete_logs.dart';
import 'page_log.dart';

class PageLogs extends StatefulWidget {
  final Settings settings;
  final Logs logs;

  const PageLogs({super.key, required this.settings, required this.logs});

  @override
  State<PageLogs> createState() => PageLogsState();
}

class PageLogsState extends State<PageLogs> {
  void _confirmDeleteLogs() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogDeleteLogs(this);
      },
    );
  }

  void _confirmDeleteLog(Log l) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogDeleteLog(this, l);
      },
    );
  }

  void pressedDeleteLog(Log l) async {
    deleteLog(l);

    ScaffoldMessenger.of( context,
    ).showSnackBar(SnackBar(content: Text("Log deleted",
      textAlign: TextAlign.center,)));

    refreshPage();
  }

  void pressedDeleteLogs() async {
    deleteAllLogs();

    ScaffoldMessenger.of( context,
    ).showSnackBar(SnackBar(content: Text("Logs deleted",
      textAlign: TextAlign.center,)));

    refreshPage();
  }

  Future<void> refreshPage() async {
    widget.logs.list = [];

    final files = await localLogs();
    files.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    for (int i = 0; i < files.length; i++) {
      Log? l = Log();
      l = await l.load(files[i]);
      if (l != null) {
        widget.logs.list.add(l);
      }
    }

    setState(() {});
  }

  IconData _iconDelete () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.clear_circled,
      "macos" => CupertinoIcons.clear_circled,
      _ => Icons.cancel_outlined
    };
  }

  IconData _iconDeleteAll () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.clear_circled,
      "macos" => CupertinoIcons.clear_circled,
      _ => Icons.playlist_remove
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Logs"),
          actions: <Widget> [
            IconButton(
              icon: Icon(_iconDeleteAll()),
              tooltip: 'Delete Logs',
              onPressed: _confirmDeleteLogs
              )
          ]
        ),
        body: RefreshIndicator(
          onRefresh: refreshPage,
          child: ListView(
          children:
          widget.logs.list.isEmpty
              ? [ListTile(title: Text("There are no logs yet")),
                ListTile(title: Text("Swipe down to refresh this screen as needed"))]
              : widget.logs.list.map((l) =>
              SlidableAutoCloseBehavior(
                  closeWhenTapped: true,
                  child: Slidable(
                  startActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: .1,
                    children: [
                      SlidableAction(
                          onPressed: (c) => _confirmDeleteLog(l),
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          backgroundColor: Colors.red,
                          icon: _iconDelete()
                      ),
                    ],
                  ),

                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: .1,
                    children: [
                      SlidableAction(
                          onPressed: (c) => _confirmDeleteLog(l),
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          backgroundColor: Colors.red,
                          icon: _iconDelete()
                      ),
                    ],
                  ),

                  child: ListTile(
                    title: Text("${DateFormat.yMMMMd().format(l.created ?? DateTime.now())}, ${DateFormat.Hm().format(l.created ?? DateTime.now())}" ),
                    subtitle: l.identifier != null ? Text(l.identifier ?? "") : null,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (context) => PageLog(log: l, settings: widget.settings)
                          )
                      );
                    },
                  )
              ))
              ).toList(),
        )
      )
    );
  }
}