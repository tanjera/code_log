import 'package:flutter/material.dart';

class Event {
  late String name;
  late String? description;
  late Color? color;
  bool favorite = false;

  Event(this.name, this.description, this.color);

  Event.m ({required this.name, required this.description, required this.color, required this.favorite});

  String? operator [] (String key) {
    switch (key) {
      case 'name':
        return name;
      case 'description':
        return description ?? "";
      case 'color':
        return color?.toARGB32().toString();
      case 'favorite':
        return favorite.toString();
      default:
        return "";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'color': color?.toARGB32().toString(),
      'favorite': favorite,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event.m(
        name: json['name'] as String,
        description: json['description'] as String,
        color: json['color'] == null ? null : Color(int.parse(json['color'])) as Color?,
        favorite: json['favorite'] as bool,
    );
  }
}