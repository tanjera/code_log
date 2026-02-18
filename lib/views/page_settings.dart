import 'package:flutter/material.dart';

import 'package:change_case/change_case.dart';

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
      widget.settings.save();
    });
  }

  void _setMetronomeAutoRun (bool? auto) {
    setState(() {
      widget.settings.metronomeAutoRun = auto ?? false;
      widget.settings.save();
    });
  }

  void _setEventLogCompact (bool? compact) {
    setState(() {
      widget.settings.eventLogCompact = compact ?? false;
      widget.settings.save();
    });
  }

  void _setPDFPageSize (PageSizes? p) {
    setState(() {
      widget.settings.pdfPageSize = p ?? widget.settings.pdfPageSize;
      widget.settings.save();
    });
  }

  Future<void> refreshPage() async {
    setState(() {});
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

          ListTile(
              title: Text("Compact event log text?"),
              trailing: Checkbox(
                  value: widget.settings.eventLogCompact,
                  onChanged: _setEventLogCompact
              )
          ),

          ListTile(
              title: Text("Event log export page size"),
              trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [DropdownButton(
                      value: widget.settings.pdfPageSize,
                      items: PageSizes.values.map<DropdownMenuItem<PageSizes>>((PageSizes p) {
                        return DropdownMenuItem<PageSizes>(
                          value: p,
                          child: Text(p.name.toTitleCase())
                        );
                      }).toList(),
                      onChanged: _setPDFPageSize
                  )
                  ]
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
