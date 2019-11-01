import 'package:broomball_app/pages/player_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:broomball_app/pages/contributor_page.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Color(0xFFFFCD00),
            title: Text("About")),
        body:
          Container(
              padding: EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(5),
          child:
            ListView(
            children: ListTile.divideTiles(
                context: context,
                tiles:
            [
              ListTile(
              title: Text('What is this?'),
                  subtitle: Text("Mobile application to view broomball info and stats based off the pre-existing MTU website."),
                  onTap: () {
                    launch('https://www.broomball.mtu.edu/news');
          }
              ),
              ListTile(
                  title: Text('Contributors'),
                  subtitle:
                Text('CS 3141 Fall 2019 Team P'),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ContributorPage())
                    );
                  }
              ),
              ListTile(
                  title: Text('Developed using Flutter and Dart'),
                  subtitle:
                  Text('Open Source Google UI Devkit'),
                  onTap: () {
                    launch('https://flutter.dev/showcase');
                  }
              ),
            ]
        ).toList()
          )
          )
    );
  }

}