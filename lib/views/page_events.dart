import 'package:codebluelog/views/dialog_event_free_text.dart';
import 'package:flutter/material.dart';

import 'dialog_event_vital_signs.dart';
import 'page_recorder.dart';
import '../classes/log.entry.dart';
import '../classes/events.dart';

class Note {
  String? text;

  Note();
}

class VitalSigns {
  int? hr;
  int? rr;
  int? spo2;
  int? sbp;
  int? dbp;
  int? etco2;
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
        return DialogEventVitalSigns();
      },
    );

    if (vs != null) {
      String desc = "Vital signs:\n";

      if (vs.hr != null) {
        desc += "- Heart rate (HR): ${vs.hr}\n";
      }
      if (vs.sbp != null || vs.dbp != null) {
        desc += "- Blood pressure (BP): ${vs.sbp} / ${vs.dbp ?? 0}\n";
      }
      if (vs.rr != null) {
        desc += "- Respiratory rate (RR): ${vs.rr}\n";
      }
      if (vs.spo2 != null) {
        desc += "- Pulse oximetry (SpO2): ${vs.spo2}\n";
      }
      if (vs.etco2 != null) {
        desc += "- End-tidal Capnometry (ETCO2): ${vs.etco2}\n";
      }
      if (vs.t != null) {
        desc += "- Temperature (T): ${vs.t!.toStringAsFixed(1)}";
      }

      if (vs.hr != null || vs.sbp != null || vs.dbp != null || vs.rr != null
          || vs.spo2 != null || vs.etco2 != null || vs.t != null) {
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

  Future<void> getFreeText(BuildContext context) async {
    final note = await showDialog<Note>(
      context: context,
      builder: (BuildContext context) {
        return DialogEventFreeText();
      },
    );

    if (note != null && note.text != null) {
      String desc = "Free text note: ${note.text}";

      _prs.log.add(Entry(
          type: EntryType.event,
          description: desc.trim()
      ));
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
      body: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: .start,
              children: _events.list.map((e) =>
                ListTile(
                  title: Text(e.name),
                  trailing: e.color != null ? CircleAvatar(backgroundColor: e.color) : null,
                  onTap: () {
                    if (e.name == "Other (Free Text)") {
                      getFreeText(context);
                    } else if (e.name == "Vital Signs") {
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
      )
    );
  }
}