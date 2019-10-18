import 'package:broomball_app/fragments/conference_fragment.dart';
import 'package:broomball_app/fragments/players_fragment.dart';
import 'package:broomball_app/fragments/teams_fragment.dart';
import 'package:broomball_app/pages/settings_page.dart';
import 'package:broomball_app/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Class that contains fragments for Conferences, Teams, and Players
/// as well as a navigation drawer

class MainPage extends StatefulWidget {
  final drawerItems = <DrawerItem>[
    new DrawerItem("Conferences", Icons.assignment),
    new DrawerItem("Teams", Icons.people),
    new DrawerItem("Players", Icons.person),
  ];

  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  int _drawerIndex = 0;

  Widget _getDrawerItemFragment(int index) {
    switch (index) {
      case 0:
        return new ConferenceFragment();
      case 1:
        return new TeamsFragment();
      case 2:
        return new PlayersFragment();
      default:
        return new Text("Error");
    }
  }

  void _onSelectDrawerItem(int index) {
    setState(() => _drawerIndex = index);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerListTiles = [];

    for (int i = 0; i < widget.drawerItems.length; i++) {
      DrawerItem drawerItem = widget.drawerItems[i];

      drawerListTiles.add(ListTile(
        leading: Icon(drawerItem.icon),
        title: Text(drawerItem.text),
        selected: i == _drawerIndex,
        onTap: () => _onSelectDrawerItem(i),
      ));
    }

    drawerListTiles.add(Divider());
    drawerListTiles.add(ListTile(
        leading: Icon(Icons.settings),
        title: Text("Settings"),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => SettingsPage()));
        }));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.drawerItems[_drawerIndex].text),
      ),
      drawer: Drawer(
        child: ListView(
          children: drawerListTiles,
        ),
      ),
      body: _getDrawerItemFragment(_drawerIndex),
    );
  }
}
