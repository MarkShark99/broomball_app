import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:broomball_app/pages/contributors_page.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text("About")),
        body: Container(
            padding: EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(5),
            child: ListView(
                children: ListTile.divideTiles(context: context, tiles: [
              ListTile(
                  title: Text("About"),
                  subtitle: Text(
                      "Mobile application to view broomball info and stats based off the pre-existing MTU website."),
                  onTap: () {
                    launch("https://www.broomball.mtu.edu/news");
                  }),
              ListTile(
                  title: Text("Contributors"),
                  subtitle: Text("Geoff Inc."),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ContributorsPage()));
                  }),
              ListTile(
                  title: Text("Developed using Flutter and Dart"),
                  subtitle: Text("Open Source Google UI Devkit"),
                  onTap: () {
                    launch("https://flutter.dev/showcase");
                  }),
            ]).toList())));
  }
}
