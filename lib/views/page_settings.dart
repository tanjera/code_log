import 'package:flutter/material.dart';

import '../classes/settings.dart';
import 'page_about.dart';

class PageSettings extends StatefulWidget {
  final Settings settings;

  const PageSettings({super.key, required this.settings});

  @override
  State<PageSettings> createState() => PageSettingsState();
}

class PageSettingsState extends State<PageSettings> {
  void _setMetronomeRate (int? rate) {
    setState(() {
      widget.settings.metronomeRate = rate ?? 100;
      widget.settings.write();
    });
  }

  void _setMetronomeAutoRun (bool? auto) {
    setState(() {
      widget.settings.metronomeAutoRun = auto ?? false;
      widget.settings.write();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Settings"),
      ),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          ListTile(
              title: Text("Metronome rate"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [DropdownButton(
                    value: widget.settings.metronomeRate,
                    items: widget.settings.metronomeOptions.map((int o) =>
                        DropdownMenuItem<int>(
                            value: o,
                            child: Text("$o")
                        )
                    ).toList(),
                      onChanged: _setMetronomeRate
                    ),
                  Text("bpm")
                ]
              )
          ),

          ListTile(
              title: Text("Automatically run metronome in codes?"),
              trailing: Checkbox(
                  value: widget.settings.metronomeAutoRun,
                  onChanged: _setMetronomeAutoRun
              )
          ),

          Divider(),

          ListTile(
            title: Text("About Code Blue Log"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => PageAbout()
                  )
              );
            }
          )
        ],
      )
    );
  }
}
