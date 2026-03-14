import 'dart:io';

import 'package:flutter/cupertino.dart';
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
  Future<void> _sharePDF() async {
    final file = await widget.log.pdf(widget.settings.pdfPageSize);

    final String desc =
        "${DateFormat.yMMMMd().format(widget.log.created ?? DateTime.now())}, ${DateFormat.Hm().format(widget.log.created ?? DateTime.now())}"
        "${widget.log.identifier == null ? "" : ": ${widget.log.identifier}"}";

    XFile xf = XFile(file.path, mimeType: "application/pdf");

    try {
      if (Platform.isIOS && context.mounted) {
        final box = context.findRenderObject() as RenderBox?;

        await SharePlus.instance.share(
          ShareParams(
            files: [xf],
            text: desc,
            subject: desc,
            downloadFallbackEnabled: true,
            sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
          ),
        );
      } else if (!Platform.isIOS) {
        await SharePlus.instance.share(
          ShareParams(
            files: [xf],
            text: desc,
            subject: desc,
            downloadFallbackEnabled: true,
          ),
        );
      }
    } catch (e) {
      // ...
    }
  }

  Future<void> _refreshPage() async {
    Log l = widget.log;
    Log? load;

    l.filename ??= "log_${l.created!.toIso8601String()}.json";
    load = await l.load(l.filename ?? "");

    setState(()  {
      if (load != null) {
        // Can't assign widget.log (final) so must assign entries instead
        widget.log.entries = load.entries;
      }
    });
  }

  IconData _iconDelete () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.clear_circled,
      "macos" => CupertinoIcons.clear_circled,
      _ => Icons.playlist_remove
    };
  }

  IconData _iconShare () {
    return switch (Platform.operatingSystem) {
      "ios" => CupertinoIcons.share,
      "macos" => CupertinoIcons.share,
      _ => Icons.share_outlined
    };
  }

  IconData _iconOpenSlider () {
    return switch (Platform.operatingSystem) {
      _ => Icons.arrow_right_rounded
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Log Viewer"),
        actions: <Widget>[
          IconButton(
            icon: Icon(_iconShare()),
            tooltip: 'Share Log',
            onPressed: _sharePDF,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: SafeArea(
          child: Column(
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
                        child: Text("Date & Time:"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "${DateFormat.yMMMMd().format(widget.log.created ?? DateTime.now())}, ${DateFormat.Hm().format(widget.log.created ?? DateTime.now())}",
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Identifier:"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(widget.log.identifier ?? "--"),
                      ),
                    ],
                  ),
                ],
              ),

              Expanded(
                child: ListView(
                  scrollDirection: .vertical,
                  children: widget.log.entries.map(
                        (item) => SlidableAutoCloseBehavior(
                          closeWhenTapped: true,
                          child: Slidable(
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: .1,
                            children: [
                              SlidableAction(
                                onPressed: (c) => setState(() {
                                  item.redacted = !item.redacted;
                                  widget.log.save();
                                }),
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor: Colors.red,
                                icon: _iconDelete(),
                              ),
                            ],
                          ),

                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            extentRatio: .1,
                            children: [
                              SlidableAction(
                                onPressed: (c) => setState(() {
                                  item.redacted = !item.redacted;
                                  widget.log.save();
                                }),
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                backgroundColor: Colors.red,
                                icon: _iconDelete(),
                              ),
                            ],
                          ),

                          child: Builder(
                              builder: (ltContext) {
                                return Row(
                                  children: [
                                    Padding(
                                        padding: .only(left: 5),
                                        child: InkWell(
                                            onTap:() => Slidable.of(ltContext)?.openStartActionPane(),
                                            borderRadius: BorderRadius.circular(50.0),
                                            child: Icon(_iconOpenSlider(),
                                                color: Theme
                                                    .of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant
                                                    .withAlpha(50))
                                        ),
                                    ),

                                    Expanded(
                                      child: Padding(
                                        padding: widget.settings.eventLogCompact
                                            ? .symmetric(
                                            horizontal: 10, vertical: 5)
                                            : .symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Text(
                                          "${item['occurred']}:\t${item['description']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: item.redacted ? Theme
                                                .of(context)
                                                .colorScheme
                                                .onSurface
                                                .withAlpha(150) : Theme
                                                .of(context)
                                                .colorScheme
                                                .onSurface,
                                            decoration: item.redacted
                                                ? .lineThrough
                                                : null,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              })
                        )),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
