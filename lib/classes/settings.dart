import 'dart:convert';

import 'utility.dart';


import '../classes/drugs.dart';
import '../classes/events.dart';
import '../classes/procedures.dart';
import '../classes/rhythms.dart';


import '../models/drug.dart';
import '../models/event.dart';
import '../models/procedure.dart';
import '../models/rhythm.dart';

enum AlertTypes {
  none,
  audio,
  visual,
  both
}

enum DeleteModes {
  delete,
  redact
}

enum PageSizes {
  letter,
  a4
}

enum Themes {
  dark,
  light,
  system
}

class Settings {
  Themes defaultTheme = .system;
  int metronomeRate = 100;
  bool metronomeAutoRun = true;
  AlertTypes alertCPRTimer = AlertTypes.both;
  bool eventLogCompact = false;
  DeleteModes eventDeleteMode = DeleteModes.redact;
  PageSizes pdfPageSize = PageSizes.letter;

  List<Drug> listDrugs = [];
  List<Event> listEvents = [];
  List<Procedure> listProcedures = [];
  List<Rhythm> listRhythms = [];

  final List<int> metronomeOptions = [
    100, 110, 120
  ];

  Future<void> initLists() async {
    bool toSave = false;
    if (listDrugs.isEmpty) {
      listDrugs = Drugs().defaultList;
      toSave = true;
    }

    if (listEvents.isEmpty) {
      listEvents = Events().defaultList;
      toSave = true;
    }

    if (listProcedures.isEmpty) {
      listProcedures = Procedures().defaultList;
      toSave = true;
    }

    if (listRhythms.isEmpty) {
      listRhythms = Rhythms().defaultList;
      toSave = true;
    }

    if (toSave) {
      save();
    }
  }

  void save() async {
    String filename = "settings.json";
    final file = await localFile(filename);

    file.writeAsString(
        JsonEncoder.withIndent("  ").convert({
          "defaultTheme": defaultTheme.name,
          "metronomeRate": metronomeRate,
          "metronomeAutoRun": metronomeAutoRun,
          "alertCPRTimer": alertCPRTimer.name,
          "eventLogCompact": eventLogCompact,
          "deleteMode": eventDeleteMode.name,
          "pdfPageSize": pdfPageSize.name,
          "listDrugs": listDrugs.map((e) => e.toJson()).toList(),
          "listEvents": listEvents.map((e) => e.toJson()).toList(),
          "listProcedures": listProcedures.map((e) => e.toJson()).toList(),
          "listRhythms": listRhythms.map((e) => e.toJson()).toList(),
        }),
        flush: true);
  }

  Future<void> load () async {
    try {
      String filename = "settings.json";
      final file = await localFile(filename);
      if (await file.exists() == false) {
        return;
      }

      String? input = await file.readAsString();

      if (input.isEmpty) {
        return;
      }

      var dAll = json.decode(input);
      defaultTheme = dAll["defaultTheme"] != null ? Themes.values.byName(dAll["defaultTheme"]) : defaultTheme;
      metronomeRate = dAll["metronomeRate"] ?? metronomeRate;
      metronomeAutoRun = dAll["metronomeAutoRun"] ?? metronomeAutoRun;
      alertCPRTimer = dAll["alertCPRTimer"] != null ? AlertTypes.values.byName(dAll["alertCPRTimer"]) : alertCPRTimer;
      eventLogCompact = dAll["eventLogCompact"] ?? eventLogCompact;
      eventDeleteMode = dAll["deleteMode"] != null ? DeleteModes.values.byName(dAll["deleteMode"]) : eventDeleteMode;
      pdfPageSize = dAll["pdfPageSize"] != null ? PageSizes.values.byName(dAll["pdfPageSize"]) : pdfPageSize;

      listDrugs = (dAll["listDrugs"] as List<dynamic>)
          .map((e) => Drug.fromJson(e as Map<String, dynamic>))
          .toList();

      listEvents = (dAll["listEvents"] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList();

      listProcedures = (dAll["listProcedures"] as List<dynamic>)
          .map((e) => Procedure.fromJson(e as Map<String, dynamic>))
          .toList();

      listRhythms = (dAll["listRhythms"] as List<dynamic>)
          .map((e) => Rhythm.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return;
    }
  }
}