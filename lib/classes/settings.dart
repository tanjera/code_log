import 'dart:convert';
import 'dart:io';

import 'utility.dart';

class Settings {
  int metronomeRate = 100;
  bool metronomeAutoRun = false;

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
        return null;
      }

      var dAll = json.decode(input);
      metronomeRate = dAll["metronomeRate"] ?? metronomeRate;
      metronomeAutoRun = dAll["metronomeAutoRun"] ?? metronomeAutoRun;

    } catch (e) {
      return;
    }
  }
}