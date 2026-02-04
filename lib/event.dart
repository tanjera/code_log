import 'package:intl/intl.dart';

enum EventType {
  CPR,
  Drug,
  Shock,
  Procedure,
  Event
}

class Event {
  late DateTime occurred;
  EventType type;
  String description;

  Event ({required this.type, required this.description}) {
    occurred = DateTime.now();
  }

  String operator [](String key) {
    switch (key) {
      case 'occurred':
        return DateFormat.Hms().format(occurred);
      case 'type':
        return type.toString();
      case 'description':
        return description;
      default:
        return "";
    }
  }
}