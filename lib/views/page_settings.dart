import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});

  @override
  State<PageSettings> createState() => PageSettingsState();
}

class PageSettingsState extends State<PageSettings> {
  String _version = "";

  PageSettingsState() {
    getVersion();
  }

  void getVersion () async {
    PackageInfo pi = await PackageInfo.fromPlatform();

    setState(() {
      _version = "${pi.version}+${pi.buildNumber}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Settings"),
      ),
      body: Column(
        mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const <int, TableColumnWidth>{
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(3),
                },
                children: [
                  TableRow(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Text("Version:")
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(_version),
                        )
                      ]
                  )

                ]
              ),
            ),
        ]
      )
    );
  }
}
