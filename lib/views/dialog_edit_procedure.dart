import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import '../models/procedure.dart';

class DialogEditProcedure extends StatelessWidget {
  final Procedure procedure;
  final _contTitle = TextEditingController();
  final _contSubtitle = TextEditingController();
  final _contLog = TextEditingController();

  DialogEditProcedure(this.procedure, {super.key}) {
    _contTitle.text = procedure.title;
    _contLog.text = procedure.log;

    if (procedure.subtitle != null) {
      _contSubtitle.text = procedure.subtitle ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Procedure'),
      scrollable: true,
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: .symmetric(vertical: 5),
              child: TextField(
                controller: _contTitle,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  border: OutlineInputBorder(),
                  labelText: "List Title (Required)",
                ),
                onChanged: (v) {
                    procedure.title = v;
                },
              ),
            ),

            Padding(
              padding: .symmetric(vertical: 5),
              child: TextField(
                controller: _contSubtitle,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  border: OutlineInputBorder(),
                  labelText: 'List Subtitle (Optional)',
                ),
                onChanged: (v) {
                  procedure.subtitle = v;
                },
              ),
            ),

            Padding(
              padding: .only(top: 5),
              child: TextField(
                controller: _contLog,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  border: OutlineInputBorder(),
                  labelText: 'Event Log Description (Optional)',
                ),
                onChanged: (v) {
                  procedure.log = v;
                },
              ),
            ),

            ColorPicker(
              color: procedure.color ?? Colors.transparent,
              onColorChanged: (v) { procedure.color = v;},
              width: 30,
              height: 30,
              borderRadius: 15,
              heading: Text(
                'Badge color',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              subheading: Text('Badge shade'),
            ),
          ]
      ),

      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme
              .of(context)
              .textTheme
              .labelLarge),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme
              .of(context)
              .textTheme
              .labelLarge),
          child: const Text('Save'),
          onPressed: () async {
            Navigator.of(context).pop(procedure);
          },
        ),
      ],
    );
  }
}