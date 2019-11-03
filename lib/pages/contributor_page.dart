import 'package:flutter/material.dart';

class ContributorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xFFFFCD00),
          title: Text("Development Team")),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Paul Rayment"),
            subtitle: Text("Developer"),
          ),
          ListTile(
            title: Text("Michael Thorburn"),
            subtitle: Text("Developer"),
          ),
          ListTile(
            title: Text("Julien Thrum"),
            subtitle: Text("Developer"),
          ),
          ListTile(
            title: Text("Mark Washington"),
            subtitle: Text("Developer"),
          ),
        ],
      ),
    );
  }
}