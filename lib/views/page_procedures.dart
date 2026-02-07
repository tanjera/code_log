import 'package:code_blue_log/views/page_recorder.dart';
import 'package:flutter/material.dart';

import 'page_main.dart';
import '../classes/procedures.dart';
import '../classes/log.entry.dart';

class PageProcedures extends StatelessWidget {
  final PageRecorderState _prs;
  final Procedures _procedures = Procedures();

  PageProcedures(this._prs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Procedures"),
      ),
      body: Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: .start,
              children: _procedures.list.map((p) =>
                ListTile(
                  title: Text(p.title),
                  subtitle: p.subtitle != null ? Text(p.subtitle!) : null,
                  trailing: p.color != null ? CircleAvatar(backgroundColor: p.color) : null,
                  onTap: () {
                    _prs.log.add(Entry(
                      type: EntryType.procedure,
                              description: p.log));
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