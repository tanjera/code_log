import 'package:code_blue_log/views/page_recorder.dart';
import 'package:flutter/material.dart';

import '../classes/log.entry.dart';
import '../classes/drugs.dart';

class PageDrugs extends StatelessWidget {
  final PageRecorderState _prs;
  final Drugs _drugs = Drugs();

  PageDrugs(this._prs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Drugs"),
      ),
      body: Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: .start,
              children: _drugs.list.map((d) =>
                  ListTile(
                    title: Text(d.name),
                    subtitle: d.route != null ? Text(d.route!) : null,
                    trailing: d.color != null ? CircleAvatar(backgroundColor: d.color) : null,
                    onTap: () {
                      if (d.name == "Epinephrine") {
                        _prs.pressedEpi();
                      } else {
                        if (d.route == null) {
                          _prs.log.add(Entry(type: EntryType.drug,
                              description: "${d.name} administered"));
                        } else {
                          _prs.log.add(Entry(type: EntryType.drug,
                              description: "${d.name} (${d
                                  .route}) administered"));
                        }
                      }
                      Navigator.pop(context);
                    },
                  )
              ).toList()
          )
        )
      )
    );
  }
}