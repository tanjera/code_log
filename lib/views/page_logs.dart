import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/log.dart';
import '../classes/utility.dart';

import 'dialog_delete_logs.dart';
import 'page_log.dart';

class PageLogs extends StatefulWidget {
  const PageLogs({super.key});

  @override
  State<PageLogs> createState() => PageLogsState();
}

class PageLogsState extends State<PageLogs> {
  List<Log> _logs = [];

  PageLogsState() {
    refreshPage();
  }

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
    _logs = [];

    final files = await localLogs();
    files.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    for (int i = 0; i < files.length; i++) {
      Log? l = Log();
      l = await l.read(files[i]);
      if (l != null) {
        _logs.add(l);
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
          _logs.isEmpty
              ? [ListTile(title: Text("There are no logs yet")),
                ListTile(title: Text("Swipe down to refresh this screen as needed"))]
              : _logs.map((l) =>
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