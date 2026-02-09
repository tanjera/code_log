import 'package:flutter/material.dart';

import 'page_about.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});

  @override
  State<PageSettings> createState() => PageSettingsState();
}

class PageSettingsState extends State<PageSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Settings"),
      ),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          ListTile(
            title: Text("About Code Blue Log"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => PageAbout()
                  )
              );
            }
          )
        ],
      )
    );
  }
}
