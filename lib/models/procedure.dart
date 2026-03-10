import 'package:flutter/material.dart';

class Procedure {
  late String title;
  late String? subtitle;
  late String log;
  late Color? color;
  bool favorite = false;

  Procedure(this.title, this.subtitle, this.log, this.color);

  Procedure.m ({required this.title, required this.subtitle, required this.log, required this.color, required this.favorite});

  Procedure clone () {
    Procedure c = Procedure(title, subtitle, log, color);
    c.favorite = favorite;
    return c;
  }

  String? operator [] (String key) {
    switch (key) {
      case 'title':
        return title;
      case 'subtitle':
        return subtitle;
      case 'log':
        return log;
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
      'title': title,
      'subtitle': subtitle,
      'log': log,
      'color': color?.toARGB32().toString(),
      'favorite': favorite,
    };
  }

  factory Procedure.fromJson(Map<String, dynamic> json) {
    return Procedure.m(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      log: json['log'] as String,
      color: json['color'] == null ? null : Color(int.parse(json['color'])) as Color?,
      favorite: json['favorite'] as bool,
    );
  }
}