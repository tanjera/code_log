import 'dart:core';
import 'package:flutter/material.dart';

import 'page_reset_list.dart';

class DialogResetList extends StatelessWidget {

  const DialogResetList({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reset List?'),
      content: const Text("Are you sure you want to reset this list? This action cannot be undone!"
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme
              .of(context)
              .textTheme
              .labelLarge),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme
              .of(context)
              .textTheme
              .labelLarge),
          child: const Text('Reset',
              style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}