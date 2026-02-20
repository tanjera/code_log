import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:share_plus/share_plus.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../classes/log.dart';
import '../classes/settings.dart';

class PageLog extends StatefulWidget {
  final Settings settings;

  const PageLog({super.key, required this.settings, required this.log});

  final Log log;

  @override
  State<PageLog> createState() => PageLogState();
}

class PageLogState extends State<PageLog> {

  Future<void> _sharePDF () async {
    final file = await widget.log.pdf(widget.settings.pdfPageSize);

    final String desc = "${DateFormat.yMMMMd().format(widget.log.created ?? DateTime.now())}, ${DateFormat.Hm().format(widget.log.created ?? DateTime.now())}"
        "${widget.log.identifier == null ? "" : ": ${widget.log.identifier}"}";

    XFile xf = XFile(file.path,
      mimeType: "application/pdf");

    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [xf],
          text: desc,
          subject: desc,
          downloadFallbackEnabled: true,
        ),
      );
    } catch (e) {
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Log Viewer"),
          actions: <Widget> [
            IconButton(
                icon: Icon(Icons.share_outlined),
                tooltip: 'Share Log',
                onPressed: _sharePDF
            )
          ]
        ),
        body: SafeArea(
            child: Column (
            mainAxisAlignment: .start,
            crossAxisAlignment: .stretch,
            children: [
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

              Expanded( child:ListView(
                  scrollDirection: .vertical,
                  children: widget.log.entries.map((item) =>
                      Slidable(
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: .1,
                            children: [
                              SlidableAction(
                                onPressed: (c) => setState(() {
                                  item.redacted = !item.redacted;
                                  widget.log.save();
                                }),
                                backgroundColor: item.redacted ? Colors.green : Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete_outlined,
                              ),
                            ],
                          ),

                          child: Row(children:[ Padding(
                            padding: widget.settings.eventLogCompact
                                ? .symmetric(horizontal: 10, vertical: 5)
                                : .symmetric(horizontal: 10, vertical: 10),
                            child: Text("${item['occurred']}:\t${item['description']}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: item.redacted ? Colors.grey : Colors.black,
                                  decoration: item.redacted ? .lineThrough : null ),
                            ),
                          )]
                          )
                      )
                  ).toList()
              )
              )
            ],
          )
        )
    );
  }
}