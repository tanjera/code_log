import 'package:flutter/material.dart';

class Rhythm {
  late String name;
  late Color? color;
  bool favorite = false;

  Rhythm(this.name, this.color);

  Rhythm.m ({required this.name, required this.color, required this.favorite});

  Rhythm clone () {
    Rhythm c = Rhythm(name, color);
    c.favorite = favorite;
    return c;
  }

  String? operator [] (String key) {
    switch (key) {
      case 'name':
        return name;
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
      'color': color?.toARGB32().toString(),
      'favorite': favorite,
    };
  }

  factory Rhythm.fromJson(Map<String, dynamic> json) {
    return Rhythm.m(
      name: json['name'] as String,
      color: json['color'] == null ? null : Color(int.parse(json['color'])) as Color?,
      favorite: json['favorite'] as bool,
    );
  }
}