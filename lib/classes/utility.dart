import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> localFile (String filename) async {
  final path = await localPath;
  return File('$path/$filename');
}

Future<List<String>> localLogs () async {
  final path = await localPath;
  final dir = Directory(path);

  List<String> files = [];

  if (await dir.exists()) {
    await for (final f in dir.list(recursive: false, followLinks: false)) {
      if (f is File) {
        var name = f.path.split('/').last;
        if (name.startsWith("log_") && name.indexOf('.json') > 0) {
          files.add(name);
        }
      }
    }
  }

  return files;
}

Future<void> deleteAllLogs () async {
  final path = await localPath;
  final dir = Directory(path);

  if (await dir.exists()) {
    await for (final f in dir.list(recursive: false, followLinks: false)) {
      if (f is File) {
        var name = f.path.split('/').last;
        if (name.startsWith("log_") && name.indexOf('.json') > 0) {
          f.delete();
        }
      }
    }
  }
}

String formatTimer(bool running, int seconds) {
  String hh = (seconds ~/ 3600).toString().padLeft(2, '0');
  String mm = ((seconds ~/ 60) % 60).toString().padLeft(2, '0');
  String ss = (seconds % 60).toString().padLeft(2, '0');

  if (hh == "00") {
    if (mm == "00" && ss == "00" && !running) {
      return "--:--";
    } else {
      return '$mm:$ss';
    }
  } else {
    return '$hh:$mm:$ss';
  }
}