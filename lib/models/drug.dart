import 'package:flutter/material.dart';

class Drug {
  late String name;
  late String? route;
  late Color? color;
  bool favorite = false;

  Drug(this.name, this.route, this.color);

  Drug.m ({required this.name, required this.route, required this.color, required this.favorite});

  String? operator [] (String key) {
    switch (key) {
      case 'name':
        return name;
      case 'route':
        return route;
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
      'route': route,
      'color': color?.toARGB32().toString(),
      'favorite': favorite,
    };
  }

  factory Drug.fromJson(Map<String, dynamic> json) {
    return Drug.m(
      name: json['name'] as String,
      route: json['route'] as String?,
      color: json['color'] == null ? null : Color(int.parse(json['color'])) as Color?,
      favorite: json['favorite'] as bool,
    );
  }
}