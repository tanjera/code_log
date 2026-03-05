import 'package:flutter/material.dart';

import '../models/procedure.dart';


class Procedures {
  final List<Procedure> list = [
    Procedure("Arterial Line", null, "Arterial line placed", Colors.red.shade600),
    Procedure("Assisted Ventilation", "Bag-Valve-Mask (BVM) or Rescue Breathing", "Assisted ventilation", Colors.blue.shade200),
    Procedure("Bronchoscopy", null, "Bronchoscopy conducted", null),
    Procedure("Cardioversion", null, "Cardioversion completed", null),
    Procedure("Central Line", null, "Central line placed", null),
    Procedure("Chest Tube", null, "Chest tube placed", null),
    Procedure("Cricothyrotomy", null, "Cricothyrotomy placed", null),
    Procedure("Defibrillator/Pacing Pads", "Combo Pads", "Defibrillator and/or pacing pads applied", Colors.yellow),
    Procedure("Delivered Baby", null, "Delivered the baby", null),
    Procedure("End-tidal Capnometry (ETCO2)", null, "End-tidal capnometry in use", Colors.blue.shade200),
    Procedure("Fetal Heart Rate", null, "Fetal heart rate assessed", null),
    Procedure("Intraosseous Line", null, "Intraosseous line placed", Colors.yellow.shade600),
    Procedure("Intravenous Line", null, "Intravenous line placed", null),
    Procedure("Intubation", "Endotracheal (ETT)", "Endotracheal intubation", null),
    Procedure("Intubation", "Laryngeal Mask Airway (LMA)", "Laryngeal mask intubation", null),
    Procedure("Thoracotomy", null, "Thoracotomy conducted", null),
    Procedure("Tracheostomy", null, "Tracheostomy placed", null),
    Procedure("Transcutaneous Pacing", "Started", "Started transcutaneous pacing", null),
    Procedure("Transcutaneous Pacing", "Stopped", "Stopped transcutaneous pacing", null),
    Procedure("Transvenous Pacing", "Started", "Started transvenous pacing", null),
    Procedure("Transvenous Pacing", "Stopped", "Stopped transvenous pacing", null),
  ];

  Procedures() {
    // In case they are out of alphabetical order in the declaring list...
    list.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
  }
}