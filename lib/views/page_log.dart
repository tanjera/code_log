import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../classes/log.dart';
import '../classes/utility.dart';


class PageLog extends StatefulWidget {
  const PageLog({super.key, required this.log});

  final Log log;

  @override
  State<PageLog> createState() => PageLogState();
}

class PageLogState extends State<PageLog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Log Viewer"),
        ),
        body: Column (
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          children: [
            Text("Event Log",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Date & Time:")
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("${DateFormat.yMMMMd().format(widget.log.created ?? DateTime.now())}, ${DateFormat.Hm().format(widget.log.created ?? DateTime.now())}" ),
                    )
                  ]
                ),
                TableRow(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Identifier:")
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(widget.log.identifier ?? "--"),
                      )
                    ]
                )
              ]
            ),

            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(3),
                  },
                  children: widget.log.entries.map((item) =>
                      TableRow(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(item['occurred'])
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(item['description']),
                            )
                          ]
                      )
                  ).toList(),
                ),
              ),
            )
          ],
        )
    );
  }
}