import 'package:flutter/material.dart';

import '../models/event.dart';

class Events {
  List<Event> defaultList = [
    Event("Assumed Care", "Assumed care of patient", null),
    Event("Call to Receiving Facility", "Call placed to receiving facility", null),
    Event("Dispatch Received", "Dispatch received", null),
    Event("Dispatch Acknowledged", "Dispatch acknowledged", null),
    Event("En Route", "En route", null),
    Event("Medical Consult", "Medical consult placed", null),
    Event("On Scene", "Arrived on scene", null),
    Event("On Site", "Arrived on site", null),
    Event("Other (Free Text)", "Other event", Colors.green),
    Event("Return of Spontaneous Circulation (ROSC)", "Achieved return of spontaneous circulation (ROSC)", null),
    Event("Seizures", "Seizure activity noted", null),
    Event("Time of Death Pronounced", "Time of death pronounced", null),
    Event("Transferred Care", "Transferred care of patient", null),
    Event("Transporting", "Transporting patient", null),
    Event("Vital Signs", "Vital signs taken", Colors.green),
  ];

  Events () {
    // In case they are out of alphabetical order in the declaring list...
    defaultList = sort(defaultList, false);
  }

  List<Event> sort (List<Event> list, bool favorites) {
    list.sort((a, b) {
      if (favorites) {
        final f = (a.favorite ? -1 : 0).compareTo(b.favorite ? -1 : 0);
        if (f != 0) {
          return f;
        }
      }

      int c = a.name.toLowerCase().compareTo(b.name.toLowerCase());
      return (c != 0) ? c : (a.description.toLowerCase() ?? "").compareTo(b.description.toLowerCase() ?? "");
    });

    return list;
  }
}
