import 'dart:core';
import 'package:flutter/material.dart';

import 'page_logs.dart';

import '../classes/log.dart';

class DialogDeleteLog extends StatelessWidget {
  final PageLogsState _pls;
  final Log _log;

  const DialogDeleteLog(this._pls, this._log, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Log?'),
      content: const Text("Are you sure you want to delete the selected log?"
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
          child: const Text('Delete Log',
              style: TextStyle(color: Colors.red)),
          onPressed: () async {
            _pls.pressedDeleteLog(_log);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}