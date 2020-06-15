import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatelessWidget {
  String _appName;
  String _packageName;
  String _version;
  String _buildNumber;

  AboutPage() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      this._appName = packageInfo.appName;
      this._packageName = packageInfo.packageName;
      this._version = packageInfo.version;
      this._buildNumber = packageInfo.buildNumber;
    });
  }

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
                    child: Theme.of(context).brightness == Brightness.light
                        ? Image.asset("assets/icon_foreground_black.png", width: 100, height: 100)
                        : Image.asset("assets/icon_foreground_white.png", width: 100, height: 100),
                  ),
                ),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Theme.of(context).brightness == Brightness.light
                        ? Image.asset("assets/irhc_new_logo_black.png", width: 100, height: 100)
                        : Image.asset("assets/irhc_new_logo_white.png", width: 100, height: 100),
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
              subtitle: Text("Icon Designer"),
            ),
            Divider(),
            AboutListTile(
              icon: Icon(Icons.info),
              applicationIcon: FlutterLogo(),
              applicationName: "IRHC Broomball",
              applicationVersion: _version,
              applicationLegalese: "© 2019 Geoff Inc.",
            ),
          ],
        ),
      ),
    );
  }
}
