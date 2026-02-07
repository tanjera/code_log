import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'log.entry.dart';

class Log {
  String? filename;
  String? identifier;
  DateTime? created;

  List<Entry> entries = [];

  void add (Entry e) async {
    entries.add(e);
    write();
  }

  void write() async {
    created ??= DateTime.now();
    filename ??= "${created!.toIso8601String()}.json";

    final file = await _localFile(filename ?? "");

    file.writeAsString(
        JsonEncoder.withIndent("  ").convert({
          "identifier": identifier,
          "created": created!.toIso8601String(),
          "entries": entries.map((e) => e.toJson()).toList()
        }),
        flush: true);


    final l = read(filename ?? "");
  }

  Future<Log?> read (String filename) async {
    try {
      final file = await _localFile(filename);
      String? input = await file.readAsString();

      if (input.isEmpty) {
        return null;
      }

      Log log = Log();
      
      var dAll = json.decode(input ?? "");

      // Decode the header
      log.identifier = dAll["identifier"];
      log.created = DateTime.parse(dAll["created"]);

      // Decode the body of the file (the Entries)
      log.entries = (dAll["entries"] as List<dynamic>)
          .map((e) => Entry.fromJson(e as Map<String, dynamic>))
          .toList();

      return log;
    } catch (e) {
      return null;
    }
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _localFile (String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }
}