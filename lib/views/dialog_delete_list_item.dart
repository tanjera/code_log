import 'dart:core';
import 'package:flutter/material.dart';

import '../models/drug.dart';
import 'page_drugs.dart';

class DialogDeleteListItem extends StatelessWidget {

  const DialogDeleteListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Item?'),
      content: const Text("Are you sure you want to delete this item?"
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
          child: const Text('Delete',
              style: TextStyle(color: Colors.red)),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}