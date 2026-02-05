import 'package:flutter/material.dart';

class Procedure {
  late String button;
  late String log;
  late Color color;

  Procedure(this.button, this.log, this.color);
}

class Procedures {
  final List<Procedure> list = [
  Procedure("Intubation", "Intubated", Colors.blueGrey),
  Procedure("Intraosseous Line", "Intraosseous line placed", Colors.yellow.shade800),
  ];
}