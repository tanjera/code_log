import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import '../models/event.dart';

class DialogEditEvent extends StatelessWidget {
  final Event event;
  final _contName = TextEditingController();
  final _contDescription = TextEditingController();

  DialogEditEvent(this.event, {super.key}) {
    _contName.text = event.name;

    _contDescription.text = event.description ?? "";
    }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Event'),
      scrollable: true,
      content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: .symmetric(vertical: 5),
              child: TextField(
                controller: _contName,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  border: OutlineInputBorder(),
                  labelText: "List Title (Required)",
                ),
                onChanged: (v) {
                    event.name = v;
                },
              ),
            ),

            Padding(
              padding: .only(top: 5),
              child: TextField(
                controller: _contDescription,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                  border: OutlineInputBorder(),
                  labelText: 'Event Log Description (Optional)',
                ),
                onChanged: (v) {
                  event.description = v;
                },
              ),
            ),

            ColorPicker(
              color: event.color ?? Colors.transparent,
              onColorChanged: (v) { event.color = v;},
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
            Navigator.of(context).pop(event);
          },
        ),
      ],
    );
  }
}