import 'dart:convert';

import 'utility.dart';

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

class Settings {
  int metronomeRate = 100;
  bool metronomeAutoRun = true;
  AlertTypes alertCPRTimer = AlertTypes.both;
  bool eventLogCompact = false;
  DeleteModes eventDeleteMode = DeleteModes.redact;
  PageSizes pdfPageSize = PageSizes.letter;

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
          "metronomeRate": metronomeRate,
          "metronomeAutoRun": metronomeAutoRun,
          "alertCPRTimer": alertCPRTimer.name,
          "eventLogCompact": eventLogCompact,
          "deleteMode": eventDeleteMode.name,
          "pdfPageSize": pdfPageSize.name,
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
      metronomeRate = dAll["metronomeRate"] ?? metronomeRate;
      metronomeAutoRun = dAll["metronomeAutoRun"] ?? metronomeAutoRun;
      alertCPRTimer = dAll["alertCPRTimer"] != null ? AlertTypes.values.byName(dAll["alertCPRTimer"]) : alertCPRTimer;
      eventLogCompact = dAll["eventLogCompact"] ?? eventLogCompact;
      eventDeleteMode = dAll["deleteMode"] != null ? DeleteModes.values.byName(dAll["deleteMode"]) : eventDeleteMode;
      pdfPageSize = dAll["pdfPageSize"] != null ? PageSizes.values.byName(dAll["pdfPageSize"]) : pdfPageSize;

    } catch (e) {
      return;
    }
  }
}