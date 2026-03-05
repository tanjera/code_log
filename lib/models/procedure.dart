import 'package:flutter/material.dart';

class Procedure {
  late String title;
  late String? subtitle;
  late String log;
  late Color? color;

  Procedure(this.title, this.subtitle, this.log, this.color);

  Procedure.m ({required this.title, required this.subtitle, required this.log});

  String? operator [] (String key) {
    switch (key) {
      case 'title':
        return title;
      case 'subtitle':
        return subtitle;
      case 'log':
        return log;
      default:
        return "";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'log': log,
    };
  }

  factory Procedure.fromJson(Map<String, dynamic> json) {
    return Procedure.m(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      log: json['log'] as String,
    );
  }
}