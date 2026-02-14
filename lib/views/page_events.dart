import 'package:flutter/material.dart';

import 'dialog_vital_signs.dart';
import 'page_recorder.dart';
import '../classes/log.entry.dart';
import '../classes/events.dart';

class VitalSigns {
  int? hr;
  int? rr;
  int? spo2;
  int? sbp;
  int? dbp;
  double? t;

  VitalSigns();
}

class PageEvents extends StatelessWidget {
  final PageRecorderState _prs;
  final Events _events = Events();

  PageEvents(this._prs, {super.key});

  Future<void> getVitals(BuildContext context) async {
    final vs = await showDialog<VitalSigns>(
      context: context,
      builder: (BuildContext context) {
        return DialogVitalSigns();
      },
    );

    if (vs != null) {
      String desc = "Vital signs:\n";

      if (vs.hr != null) {
        desc += "• Heart rate (HR): ${vs.hr}\n";
      }
      if (vs.sbp != null || vs.dbp != null) {
        desc += "• Blood pressure (BP: ${vs.sbp} / ${vs.dbp ?? 0}\n";
      }
      if (vs.rr != null) {
        desc += "• Respiratory rate (RR): ${vs.rr}\n";
      }
      if (vs.spo2 != null) {
        desc += "• Pulse oximetry (SpO2): ${vs.spo2}\n";
      }
      if (vs.t != null) {
        desc += "• Temperature (T): ${vs.t!.toStringAsFixed(1)}";
      }

      if (vs.hr != null || vs.sbp != null || vs.dbp != null || vs.rr != null
          || vs.spo2 != null || vs.t != null) {
        _prs.log.add(Entry(
            type: EntryType.event,
            description: desc.trim()
        ));
      }
    }

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Events"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: .start,
          children: _events.list.map((e) =>
            ListTile(
              title: Text(e.name),
              onTap: () {
                if (e.name == "Vital Signs") {
                  getVitals(context);
                } else {
                  _prs.log.add(Entry(
                      type: EntryType.event,
                      description: e.description));
                  _prs.updateUI();
                  Navigator.pop(context);
                }
              },
            )
        ).toList(),
        )
    )
    );
  }
}