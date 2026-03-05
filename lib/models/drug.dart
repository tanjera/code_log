import 'package:flutter/material.dart';

class Drug {
  late String name;
  late String? route;
  late Color? color;

  Drug(this.name, this.route, this.color);

  Drug.m ({required this.name, required this.route});

  String? operator [] (String key) {
    switch (key) {
      case 'name':
        return name;
      case 'route':
        return route;
      default:
        return "";
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'route': route,
    };
  }

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug.m(
      name: json['name'] as String,
      route: json['route'] as String?
    );
  }
}