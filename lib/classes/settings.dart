class Settings {
  late int metronomeRate;

  final List<int> metronomeOptions = [
    100, 110, 120
  ];

  Settings() {
    metronomeRate = 100;
  }
}