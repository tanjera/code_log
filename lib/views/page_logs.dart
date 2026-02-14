import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/log.dart';
import '../classes/logs.dart';
import '../classes/utility.dart';

import 'dialog_delete_logs.dart';
import 'page_log.dart';

class PageLogs extends StatefulWidget {
  final Logs logs;

  const PageLogs({super.key, required this.logs});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Logs"),
            actions:
            <Widget> [
              IconButton(
                icon: Icon(Icons.delete_forever_outlined),
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
                  ListTile(
                    title: Text("${DateFormat.yMMMMd().format(l.created ?? DateTime.now())}, ${DateFormat.Hm().format(l.created ?? DateTime.now())}" ),
                    subtitle: l.identifier != null ? Text(l.identifier ?? "") : null,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (context) => PageLog(log: l)
                          )
                      );
                    },
                  )
              ).toList(),
        )
      )
    );
  }
}