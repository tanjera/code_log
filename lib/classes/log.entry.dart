import 'package:intl/intl.dart';

enum EntryType {
  cpr,
  drug,
  event,
  shock,
  rhythm,
  procedure,

}

class Entry {
  late DateTime occurred;
  EntryType type;
  String description;
  bool redacted = false;
  String notation = "";

  Entry ({required this.type, required this.description}) {
    occurred = DateTime.now();
  }

  Entry.m ({required this.occurred, required this.type, required this.description, required this.redacted, required this.notation});

  String operator [] (String key) {
    switch (key) {
      case 'occurred':
        return DateFormat.Hms().format(occurred);
      case 'type':
        return type.toString();
      case 'description':
        return description;
      case 'redacted':
        return redacted.toString();
        case 'notation':
      return notation.toString();
      default:
        return "";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'occurred': occurred.toIso8601String(),
      'type': type.toString(),
      'description': description,
      'redacted': redacted,
      'notation': notation
    };
  }

  factory Entry.fromJson(Map<String, dynamic> json) {
    return Entry.m(
      occurred: DateTime.parse(json['occurred']),
      type: EntryType.values.firstWhere((e) => e.toString() == json['type']),
      description: json['description'] as String,
      redacted: json['redacted'],
      notation: json['notation'] as String
    );
  }
}