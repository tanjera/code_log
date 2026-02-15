import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PageAbout extends StatefulWidget {
  const PageAbout({super.key});

  @override
  State<PageAbout> createState() => PageAboutState();
}

class PageAboutState extends State<PageAbout> {
  String _version = "";

  final String _aboutText = "Designed for paramedical, medical, and nursing professionals, "
      "to assist with timekeeping and informally recording events during resuscitation "
      "(code blue) events. \n\nDisclaimer: To comply with the Google Play policies, "
      "this app is not intended to function as an electronic "
      "health record, as an educational resource, as a clinical reference or guideline, or as a "
      "replacement for clinically validated and tested tooling. It is primarily designed to be a "
      "timekeeping aid and informal note-taking application.\n\nPlease follow your regional and "
      "institutional laws regarding protected health information and data management! It is "
      "recommended that you do *not* place protected health information into this app!\n\n"
      "This app is released under the Apache 2.0 license as free and open source software. "
      "Use of this software constitutes agreement with the license under which it is released.";

  PageAboutState() {
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
        title: Text("About"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                Image(image: AssetImage('assets/icon/icon_128.png'), width: 96, height: 96,),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10),
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("Code Blue Log",
                              style: TextStyle(fontSize: 24)
                        )
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("(c) 2026")
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("Ibi Keller, MSN, RN, CCRN, CEN, CNE")
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("Version: $_version")
                      )
                    ],
                  )
                )
              ]
            ),
            Padding(
              padding: EdgeInsetsGeometry.only(top: 5),
              child: Text(_aboutText),
            )
          ])
        )
      )
    );
  }
}
