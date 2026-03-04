import 'package:flutter/material.dart';

class Event {
  late String name;
  late String description;
  late Color? color;

  Event(this.name, this.description, this.color);

  Event.m ({required this.name, required this.description});

  String operator [] (String key) {
    switch (key) {
      case 'name':
        return name;
      case 'description':
        return description;
      default:
        return "";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event.m(
        name: json['name'] as String,
        description: json['description'] as String,
    );
  }
}