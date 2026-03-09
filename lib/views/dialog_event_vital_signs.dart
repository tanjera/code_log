import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'page_events.dart';

class DialogEventVitalSigns extends StatelessWidget {
  final VitalSigns _vs = VitalSigns();

  DialogEventVitalSigns({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Vital Signs'),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        Padding(
          padding: .symmetric(vertical: 5),
          child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: OutlineInputBorder(),
                labelText: 'Heart Rate',
              ),
            onChanged: (v) {
              if (v.isNotEmpty) {
                _vs.hr = int.parse(v);
              }
              },
            ),
          ),

          Padding(
            padding: .symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      border: OutlineInputBorder(),
                      labelText: 'Systolic Blood Pressure',
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty) {
                        _vs.sbp = int.parse(v);
                      }
                    },
                  ),
                ),

                Text(" / ",
                    style: TextStyle(fontSize: 20)),

                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      border: OutlineInputBorder(),
                      labelText: 'Diastolic Blood Pressure',
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty) {
                        _vs.dbp = int.parse(v);
                      }
                    },
                  ),
                ),
              ]
            ),
          ),

          Padding(
            padding: .symmetric(vertical: 5),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: OutlineInputBorder(),
                labelText: 'Respiratory Rate',
              ),
              onChanged: (v) {
                if (v.isNotEmpty) {
                  _vs.rr = int.parse(v);
                }
              },
            ),
          ),

          Padding(
            padding: .symmetric(vertical: 5),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: OutlineInputBorder(),
                labelText: 'Pulse Oximetry',
              ),
              onChanged: (v) {
                if (v.isNotEmpty) {
                  _vs.spo2 = int.parse(v);
                }
              },
            ),
          ),

          Padding(
            padding: .symmetric(vertical: 5),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: OutlineInputBorder(),
                labelText: 'End-tidal Capnometry',
              ),
              onChanged: (v) {
                if (v.isNotEmpty) {
                  _vs.etco2 = int.parse(v);
                }
              },
            ),
          ),

          Padding(
            padding: .symmetric(vertical: 5),
            child: TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))
              ],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                border: OutlineInputBorder(),
                labelText: 'Temperature',
              ),
              onChanged: (v) {
                if (v.isNotEmpty) {
                  _vs.t = double.parse(v);
                }
              },
            ),
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
            Navigator.of(context).pop(_vs);
          },
        ),
      ],
    );
  }
}