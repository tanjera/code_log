import 'dart:core';
import 'package:flutter/material.dart';

import 'page_recorder.dart';

class DialogEndCode extends StatelessWidget {
  final PageRecorderState _prs;

  const DialogEndCode(this._prs, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('End Code?'),
      content: const Text("Are you sure you want to end the code and reset the recorder?"
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme
              .of(context)
              .textTheme
              .labelLarge),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme
              .of(context)
              .textTheme
              .labelLarge),
          child: const Text('End Code',
              style: TextStyle(color: Colors.red)),
          onPressed: () {
            _prs.endCode();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}