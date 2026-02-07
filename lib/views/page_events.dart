import 'package:flutter/material.dart';

import 'page_recorder.dart';
import '../classes/log.entry.dart';
import '../classes/events.dart';


class PageEvents extends StatelessWidget {
  final PageRecorderState _prs;
  final Events _events = Events();

  PageEvents(this._prs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Events"),
        ),
        body: Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: .start,
                  children: _events.list.map((e) =>
                      ListTile(
                        title: Text(e.name),
                        onTap: () {
                          _prs.log.add(Entry(
                              type: EntryType.event,
                              description: e.description));
                          _prs.updateUI();
                          Navigator.pop(context);
                        },
                      )
                  ).toList(),
                )
            )
        )
    );
  }
}