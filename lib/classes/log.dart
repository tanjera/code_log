import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'log.entry.dart';
import 'settings.dart';
import 'utility.dart';

class Log {
  String? filename;
  String? identifier;
  DateTime? created;

  List<Entry> entries = [];

  VoidCallback? scroll;

  void add (Entry e) async {
    entries.add(e);
    save();

    if (scroll != null) {
      // Need to asynchronously wait for the TableRow to be populated in the Event Log
      // View before actually trying to scroll to it!
      await Future.delayed(const Duration(milliseconds: 500));
      scroll?.call();
    }
  }

  void save() async {
    created ??= DateTime.now();
    filename ??= "log_${created!.toIso8601String()}.json";

    final file = await localFile(filename ?? "");

    file.writeAsString(
        JsonEncoder.withIndent("  ").convert({
          "identifier": identifier,
          "created": created!.toIso8601String(),
          "entries": entries.map((e) => e.toJson()).toList()
        }),
        flush: true);
  }

  Future<Log?> load (String filename) async {
    try {
      final file = await localFile(filename);
      String? input = await file.readAsString();

      if (input.isEmpty) {
        return null;
      }

      Log log = Log();
      
      var dAll = json.decode(input);

      // Decode the header
      log.identifier = dAll["identifier"];
      log.created = DateTime.parse(dAll["created"]);

      // Decode the body of the file (the Entries)
      log.entries = (dAll["entries"] as List<dynamic>)
          .map((e) => Entry.fromJson(e as Map<String, dynamic>))
          .toList();

      return log;
    } catch (e) {
      return null;
    }
  }

  Future<File> pdf (PageSizes size) async {
      final doc = pw.Document();

      final logo = await rootBundle.load('assets/icon/icon_128.png');
      final logoBytes = logo.buffer.asUint8List();

      final pageSize = switch (size) {
        PageSizes.letter => PdfPageFormat.letter,
        PageSizes.a4 => PdfPageFormat.a4
      };

      doc.addPage(pw.MultiPage(
          orientation: pw.PageOrientation.portrait,
          pageFormat: pageSize,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          header: (pw.Context context) {
            return
              pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(
                          bottom: pw.BorderSide(width: 0.5, color: PdfColors.black))),
                  child: pw.Row(
                      mainAxisSize: .max,
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        pw.Container(
                            height: 24,
                            width: 24,
                            child: pw.Image(pw.MemoryImage(logoBytes))
                        ),
                        pw.Text("${DateFormat.yMMMMd().format(created ?? DateTime.now())}, ${DateFormat.Hm().format(created ?? DateTime.now())}${identifier == null ? "" : ": $identifier"}",
                          textScaleFactor: 1.25,
                          style: pw.Theme.of(context)
                              .defaultTextStyle
                              .copyWith(color: PdfColors.black)),
                    ]
                  )
              );
          },
          footer: (pw.Context context) {
            return pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                padding: const pw.EdgeInsets.only(top: 3.0 * PdfPageFormat.mm),
                decoration: const pw.BoxDecoration(
                    border: pw.Border(
                        top: pw.BorderSide(width: 0.5, color: PdfColors.black))),
                child: pw.Row(
                    mainAxisSize: .max,
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      pw.Text('Event Log',
                          textScaleFactor: 1.25,
                          style: pw.Theme.of(context)
                              .defaultTextStyle
                              .copyWith(color: PdfColors.black)),
                      pw.Text(
                          'Page ${context.pageNumber} of ${context.pagesCount}',
                          style: pw.Theme.of(context)
                              .defaultTextStyle
                              .copyWith(color: PdfColors.black))
                    ]
                )
            );
          },
          build: (pw.Context context) => <pw.Widget>[
            pw.TableHelper.fromTextArray(
                border: pw.TableBorder(
                    horizontalInside: pw.BorderSide(width: 0.5, color: PdfColors.grey)),
                cellAlignment: pw.Alignment.centerLeft,
                cellAlignments: {
                  0: pw.Alignment.centerLeft,
                  1: pw.Alignment.centerLeft,
                },
                data: List<List<String>>.generate(
                  entries.length,
                      (row) => [
                        (DateFormat.Hms().format(entries[row].occurred)),
                        entries[row].description
                      ]
                ),
            ),
          ]
      ));


      created ??= DateTime.now();
      filename ??= "log_${created!.toIso8601String()}.pdf";

      final file = await localFile(filename ?? "");
      await file.writeAsBytes(await doc.save());

      return file;
  }
}