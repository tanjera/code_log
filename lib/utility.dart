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