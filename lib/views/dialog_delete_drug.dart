import 'dart:core';
import 'package:flutter/material.dart';

import '../models/drug.dart';
import 'page_drugs.dart';

class DialogDeleteDrug extends StatelessWidget {
  final PageDrugsState _pds;
  final Drug _drug;

  const DialogDeleteDrug(this._pds, this._drug, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Drug?'),
      content: const Text("Are you sure you want to delete this drug?"
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
          child: const Text('Delete',
              style: TextStyle(color: Colors.red)),
          onPressed: () {
            _pds.pressedDeleteDrug(_drug);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}