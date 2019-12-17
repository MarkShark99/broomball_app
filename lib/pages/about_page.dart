import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: Text("About")),
      body: Container(
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Theme.of(context).brightness == Brightness.light ? Image(image: AssetImage("assets/icon_foreground_black.png")) : Image(image: AssetImage("assets/icon_foreground_white.png")),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Theme.of(context).brightness == Brightness.light ? Image(image: AssetImage("assets/irhc_new_logo_black.png")) : Image(image: AssetImage("assets/irhc_new_logo_white.png")),
                  ),
                ),
              ],
            ),
            Divider(),
            ListTile(
              title: Text("Contributors"),
            ),
            ListTile(
              title: Text("Mark Washington"),
              subtitle: Text("Developer"),
            ),
            ListTile(
              title: Text("Julien Thrum"),
              subtitle: Text("Developer"),
            ),
            ListTile(
              title: Text("Paul Rayment"),
              subtitle: Text("Developer"),
            ),
            ListTile(
              title: Text("Michael Thorburn"),
              subtitle: Text("Developer"),
            ),
            Divider(),
            ListTile(
              title: Text("Open Source Licenses"),
              onTap: () {},
            ),
            Divider(),
            ListTile(
              title: Text("Version 1.0.0-beta2"),
            )
          ],
        ),
      ),
    );
  }
}
