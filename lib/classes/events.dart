import '../models/event.dart';

class Events {
  List<Event> list = [
    Event("Assumed Care", "Assumed care of patient"),
    Event("Dispatch Received", "Dispatch received"),
    Event("Dispatch Acknowledged", "Dispatch acknowledged"),
    Event("En Route", "En route"),
    Event("On Scene", "Arrived on scene"),
    Event("On Site", "Arrived on site"),
    Event("Return of Spontaneous Circulation (ROSC)", "Achieved return of spontaneous circulation (ROSC)"),
    Event("Time of Death Pronounced", "Time of death pronounced"),
    Event("Transferred Care", "Transferred care of patient"),
    Event("Transporting", "Transporting patient"),
  ];

  Events () {
    // In case they are out of alphabetical order in the declaring list...
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }
}
