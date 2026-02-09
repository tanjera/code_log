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
          child: const Text('End Code',
              style: TextStyle(fontSize: 24, color: Colors.red)),
          onPressed: () {
            _prs.endCode();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}









      /*

      Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(''),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: FilledButton(
                      style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                    onPressed: () { Navigator.pop(context); },
                    child: Text("No",
                        style: TextStyle(fontSize: 24))
                )
              ),
              Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder( borderRadius: BorderRadiusGeometry.circular(5))),
                      onPressed: () {

                        Navigator.pop(context);
                      },
                    child: Text("Yes",
                        style: TextStyle(fontSize: 24))
                )
              ),
            ]
          )
        ]
      )
    );
  }
}*/