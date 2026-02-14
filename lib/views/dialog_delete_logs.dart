import 'dart:core';
import 'package:flutter/material.dart';

import 'page_logs.dart';

class DialogDeleteLogs extends StatelessWidget {
  final PageLogsState _pls;

  const DialogDeleteLogs(this._pls, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Logs?'),
      content: const Text("Are you sure you want to delete all stored logs?"
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme
              .of(context)
              .textTheme
              .labelLarge),
          child: const Text('Cancel',
              style: TextStyle(fontSize: 24)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme
              .of(context)
              .textTheme
              .labelLarge),
          child: const Text('Delete Logs',
              style: TextStyle(fontSize: 24, color: Colors.red)),
          onPressed: () async {
            _pls.pressedDeleteLogs();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}