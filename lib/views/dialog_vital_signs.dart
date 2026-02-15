import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'page_events.dart';

class DialogVitalSigns extends StatelessWidget {
  final VitalSigns _vs = VitalSigns();

  DialogVitalSigns({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Vital Signs'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Heart Rate',
            ),
          onChanged: (v) {
            if (v.isNotEmpty) {
              _vs.hr = int.parse(v);
            }
            },
          ),

          TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Systolic Blood Pressure',
              ),
              onChanged: (v) {
                if (v.isNotEmpty) {
                  _vs.sbp = int.parse(v);
                }
              },
          ),

          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Diastolic Blood Pressure',
            ),
            onChanged: (v) {
              if (v.isNotEmpty) {
                _vs.dbp = int.parse(v);
              }
            },
          ),

          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Respiratory Rate',
            ),
            onChanged: (v) {
              if (v.isNotEmpty) {
                _vs.rr = int.parse(v);
              }
            },
          ),

          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Pulse Oximetry',
            ),
            onChanged: (v) {
              if (v.isNotEmpty) {
                _vs.spo2 = int.parse(v);
              }
            },
          ),

          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Temperature',
            ),
            onChanged: (v) {
              if (v.isNotEmpty) {
                _vs.t = double.parse(v);
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
          child: const Text('Cancel',
              style: TextStyle(fontSize: 24, color: Colors.red)),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        TextButton(
          style: TextButton.styleFrom(textStyle: Theme
              .of(context)
              .textTheme
              .labelLarge),
          child: const Text('Save',
              style: TextStyle(fontSize: 24)),
          onPressed: () async {
            Navigator.of(context).pop(_vs);
          },
        ),
      ],
    );
  }
}