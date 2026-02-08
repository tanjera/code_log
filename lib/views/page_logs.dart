import 'package:flutter/material.dart';

import '../classes/log.dart';
import '../classes/utility.dart';


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
        ),
        body: RefreshIndicator(
          onRefresh: _refreshPage,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: .start,
              children: _logs.map((e) =>
                  ListTile(
                    title: Text(e.created!.toIso8601String()),
                  )
              ).toList(),
              )
          )
        )
    );
  }
}