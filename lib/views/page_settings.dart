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
      widget.settings.metronomeAutoRun = auto ?? true;
      widget.settings.save();
    });
  }

  void _setAlertCPRTimer (AlertTypes? a) {
    setState(() {
      widget.settings.alertCPRTimer = a ?? AlertTypes.both;
      widget.settings.save();
    });
  }

  void _setEventLogCompact (bool? compact) {
    setState(() {
      widget.settings.eventLogCompact = compact ?? false;
      widget.settings.save();
    });
  }

  void _setEventDeleteMode (DeleteModes? d) {
    setState(() {
      widget.settings.eventDeleteMode = d ?? widget.settings.eventDeleteMode;
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
              title: Text("CPR automates metronome?"),
              trailing: Checkbox(
                  value: widget.settings.metronomeAutoRun,
                  onChanged: _setMetronomeAutoRun
              )
          ),

          ListTile(
              title: Text("CPR metronome rate:"),
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
            title: Text("CPR alerts for pulse checks:"),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [DropdownButton(
                    value: widget.settings.alertCPRTimer,
                    items: AlertTypes.values.map<DropdownMenuItem<AlertTypes>>((AlertTypes a) {
                      return DropdownMenuItem<AlertTypes>(
                          value: a,
                          child: Text(a.name.toTitleCase())
                      );
                    }).toList(),
                    onChanged: _setAlertCPRTimer
                )
                ]
            )
          ),

          Divider(),

          ListTile(
              title: Text("Compact event log text?"),
              trailing: Checkbox(
                  value: widget.settings.eventLogCompact,
                  onChanged: _setEventLogCompact
              )
          ),
          
          ListTile(
              title: Text("Event log delete mode:"),
              trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [DropdownButton(
                      value: widget.settings.eventDeleteMode,
                      items: DeleteModes.values.map<DropdownMenuItem<DeleteModes>>((DeleteModes d) {
                        return DropdownMenuItem<DeleteModes>(
                            value: d,
                            child: Text(d.name.toTitleCase())
                        );
                      }).toList(),
                      onChanged: _setEventDeleteMode
                  )
                  ]
              )
          ),
          
          ListTile(
              title: Text("Event log export page size:"),
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
