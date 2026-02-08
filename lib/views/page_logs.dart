import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/log.dart';
import '../classes/utility.dart';

import 'page_log.dart';

class PageLogs extends StatefulWidget {
  const PageLogs({super.key});

  @override
  State<PageLogs> createState() => PageLogsState();
}

class PageLogsState extends State<PageLogs> {
  List<Log> _logs = [];

  PageLogsState() {
    _refreshPage();
  }

  Future<void> _refreshPage() async {
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
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_outlined),
              tooltip: 'Refresh',
              onPressed: () {
                _refreshPage();
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refreshPage,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: .start,
              children: _logs.map((l) =>
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
        )
    );
  }
}