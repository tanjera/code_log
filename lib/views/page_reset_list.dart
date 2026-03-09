import 'package:codebluelog/views/dialog_reset_list.dart';
import 'package:flutter/material.dart';

import '../classes/drugs.dart';
import '../classes/events.dart';
import '../classes/procedures.dart';
import '../classes/rhythms.dart';
import '../classes/settings.dart';


class PageResetList extends StatefulWidget {
  final Settings settings;

  const PageResetList({super.key, required this.settings});

  @override
  State<PageResetList> createState() => PageResetListState();
}

class PageResetListState extends State<PageResetList> {

  Future<void> _resetDrugs(BuildContext context) async {
    final reset = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DialogResetList();
      },
    );

    if (reset != null && reset == true) {
      widget.settings.listDrugs = Drugs().defaultList;
      widget.settings.save();

      ScaffoldMessenger.of( context,
      ).showSnackBar(const SnackBar(content: Text('Drug list reset.',
        textAlign: TextAlign.center,)));
    }
  }

  Future<void> _resetEvents(BuildContext context) async {
    final reset = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DialogResetList();
      },
    );

    if (reset != null && reset == true) {
      widget.settings.listEvents = Events().defaultList;
      widget.settings.save();

      ScaffoldMessenger.of( context,
      ).showSnackBar(const SnackBar(content: Text('Event list reset.',
        textAlign: TextAlign.center,)));
    }
  }

  Future<void> _resetProcedures(BuildContext context) async {
    final reset = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DialogResetList();
      },
    );

    if (reset != null && reset == true) {
      widget.settings.listProcedures = Procedures().defaultList;
      widget.settings.save();

      ScaffoldMessenger.of( context,
      ).showSnackBar(const SnackBar(content: Text('Procedure list reset.',
        textAlign: TextAlign.center,)));
    }
  }

  Future<void> _resetRhythms(BuildContext context) async {
    final reset = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return DialogResetList();
      },
    );

    if (reset != null && reset == true) {
      widget.settings.listRhythms = Rhythms().defaultList;
      widget.settings.save();

      ScaffoldMessenger.of( context,
      ).showSnackBar(const SnackBar(content: Text('Rhythm list reset.',
        textAlign: TextAlign.center,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Reset List?"),
      ),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [

          ListTile(
            title: Text("Drug list"),
            onTap: () => _resetDrugs(context),
          ),

          ListTile(
            title: Text("Event list"),
            onTap: () => _resetEvents(context),
          ),

          ListTile(
            title: Text("Procedure list"),
            onTap: () => _resetProcedures(context),
          ),

          ListTile(
            title: Text("Rhythm list"),
            onTap: () => _resetRhythms(context),
          ),
        ],
      )
    );
  }
}
