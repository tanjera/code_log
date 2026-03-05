import 'package:flutter/material.dart';

class Rhythm {
  late String name;
  late Color? color;

  Rhythm(this.name, this.color);

  Rhythm.m ({required this.name});

  String? operator [] (String key) {
    switch (key) {
      case 'name':
        return name;
      default:
        return "";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  factory Rhythm.fromJson(Map<String, dynamic> json) {
    return Rhythm.m(
      name: json['name'] as String,
    );
  }
}