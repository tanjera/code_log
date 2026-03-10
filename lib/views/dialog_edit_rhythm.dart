import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import '../models/rhythm.dart';

class DialogEditRhythm extends StatelessWidget {
  final Rhythm rhythm;
  final _contName = TextEditingController();

  DialogEditRhythm(this.rhythm, {super.key}) {
    _contName.text = rhythm.name;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Rhythm'),
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
                  labelText: "Name (Required)",
                ),
                onChanged: (v) {
                    rhythm.name = v;
                },
              ),
            ),

            ColorPicker(
              color: rhythm.color ?? Colors.transparent,
              onColorChanged: (v) { rhythm.color = v;},
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
            Navigator.of(context).pop(rhythm);
          },
        ),
      ],
    );
  }
}