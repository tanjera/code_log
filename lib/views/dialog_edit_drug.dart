import 'dart:core';
import 'package:flutter/material.dart';

import '../models/drug.dart';

class DialogEditDrug extends StatelessWidget {
  final Drug _drug;
  final _contName = TextEditingController();
  final _contRoute = TextEditingController();

  DialogEditDrug(this._drug, {super.key}) {
    _contName.text = _drug.name;

    if (_drug.route != null) {
      _contRoute.text = _drug.route ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Drug'),
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
                labelText: "Name",
              ),
            onChanged: (v) {
              if (v.isNotEmpty) {
                _drug.name = v;
              }
              },
            ),
          ),

          Padding(
            padding: .symmetric(vertical: 5),
            child: TextField(
              controller: _contRoute,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: OutlineInputBorder(),
                labelText: 'Route',
              ),
              onChanged: (v) {
                if (v.isNotEmpty) {
                  _drug.route = v;
                }
              },
            ),
          )
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
            Navigator.of(context).pop(_drug);
          },
        ),
      ],
    );
  }
}