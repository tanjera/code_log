import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'event.dart';
import 'main.dart';

enum EventType {
  CPR,
  Drug,
  Shock,
  Procedure,
  Event
}

class Event {
  late DateTime occurred;
  EventType type;
  String description;

  Event ({required this.type, required this.description}) {
    occurred = DateTime.now();
  }

  String operator [](String key) {
    switch (key) {
      case 'occurred':
        return DateFormat.Hms().format(occurred);
      case 'type':
        return type.toString();
      case 'description':
        return description;
      default:
        return "";
    }
  }
}

class Events {
  List<String> list = [
    "Assumed Care",
    "Dispatch Received",
    "Dispatch Acknowledged",
    "On Scene",
    "On Site",
    "Return of Spontaneous Circulation (ROSC)",
    "Time of Death Pronounced",
    "Transferred Care"
  ];

  Events () {
    // In case they are out of alphabetical order in the declaring list...
    list.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
  }
}

class PageEvents extends StatelessWidget {
  final PageState _pageState;
  final Events _events = Events();

  PageEvents(this._pageState, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Events"),
        ),
        body: Expanded(
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: .start,
                  children: _events.list.map((e) =>
                      ListTile(
                        title: Text(e),
                        onTap: () {
                          _pageState.events.add(Event(
                              type: EventType.Procedure,
                              description: e));
                          _pageState.updateUI();
                          Navigator.pop(context);
                        },
                      )
                  ).toList(),
                )
            )
        )
    );
  }
}