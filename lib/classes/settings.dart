import 'dart:convert';

import 'utility.dart';

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

  List<Drug> hiddenDrugs = [];
  List<Event> hiddenEvents = [];
  List<Procedure> hiddenProcedures = [];
  List<Rhythm> hiddenRhythms = [];

  final List<int> metronomeOptions = [
    100, 110, 120
  ];

  Settings() {
    try {
      load();
    } catch (e) {
      // ...
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
          "hiddenDrugs": hiddenDrugs.map((e) => e.toJson()).toList(),
          "hiddenEvents": hiddenEvents.map((e) => e.toJson()).toList(),
          "hiddenProcedures": hiddenProcedures.map((e) => e.toJson()).toList(),
          "hiddenRhythms": hiddenRhythms.map((e) => e.toJson()).toList(),
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

      hiddenDrugs = (dAll["hiddenDrugs"] as List<dynamic>)
          .map((e) => Drug.fromJson(e as Map<String, dynamic>))
          .toList();

      hiddenEvents = (dAll["hiddenEvents"] as List<dynamic>)
          .map((e) => Event.fromJson(e as Map<String, dynamic>))
          .toList();

      hiddenProcedures = (dAll["hiddenProcedures"] as List<dynamic>)
          .map((e) => Procedure.fromJson(e as Map<String, dynamic>))
          .toList();

      hiddenRhythms = (dAll["hiddenRhythms"] as List<dynamic>)
          .map((e) => Rhythm.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return;
    }
  }
}