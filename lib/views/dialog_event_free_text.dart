import 'dart:core';
import 'package:flutter/material.dart';

import 'page_events.dart';

class DialogEventFreeText extends StatelessWidget {
  final Note _note = Note();

  DialogEventFreeText({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Free Text'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter note here',
            ),
          onChanged: (v) {
            if (v.isNotEmpty) {
              _note.text = v;
            }
            },
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
            Navigator.of(context).pop(_note);
          },
        ),
      ],
    );
  }
}