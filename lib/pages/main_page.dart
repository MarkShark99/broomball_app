import 'package:broomball_app/fragments/conference_fragment.dart';
import 'package:broomball_app/fragments/schedule_fragment.dart';
import 'package:broomball_app/fragments/teams_fragment.dart';
import 'package:broomball_app/pages/about_page.dart';
import 'package:broomball_app/pages/favorites_page.dart';
import 'package:broomball_app/pages/search_page.dart';
import 'package:broomball_app/pages/settings_page.dart';
import 'package:broomball_app/util/util.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Class that contains fragments for Conferences, Teams, and Players
/// as well as a navigation drawer

class MainPage extends StatefulWidget {
  final drawerItems = <DrawerItem>[
    new DrawerItem(title: "Conferences", icon: Icons.assignment),
    new DrawerItem(title: "Teams", icon: Icons.people),
    new DrawerItem(title: "Schedule", icon: Icons.calendar_today),
  ];

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  int _currentDrawerIndex = 0;
  String _currentYear;

  List<String> _yearList = <String>[];

  Map<String, dynamic> jsonData;

  @override
  void initState() {
    super.initState();

    int currentYear = DateTime.now().year;
    this._yearList = <String>[];

    for (int i = currentYear; i >= 2002; i--) {
      this._yearList.add(i.toString());
    }

    this._currentYear = currentYear.toString();
  }

  Widget _getDrawerItemFragment(int index) {
    switch (index) {
      case 0:
        return new ConferenceFragment(
          year: _currentYear,
        );
      case 1:
        return new TeamsFragment(
          year: _currentYear,
        );
      case 2:
        return new ScheduleFragment(
          year: _currentYear,
        );
      default:
        return new Text("Error");
    }
  }

  void _onSelectDrawerItem(int index) {
    setState(() {
      _currentDrawerIndex = index;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerListTiles = [];

    for (int i = 0; i < widget.drawerItems.length; i++) {
      DrawerItem drawerItem = widget.drawerItems[i];

      drawerListTiles.add(ListTile(
        leading: Icon(drawerItem.icon),
        title: Text(drawerItem.title),
        selected: i == _currentDrawerIndex,
        onTap: () {
          _onSelectDrawerItem(i);
        },
      ));
    }

    drawerListTiles.add(ListTile(
      leading: Icon(Icons.star_border),
      title: Text("Favorites"),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return FavoritesPage();
          },
        ));
      },
    ));
    drawerListTiles.add(Divider());

    drawerListTiles.add(ListTile(
      leading: Icon(Icons.settings),
      title: Text("Settings"),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) {
            return SettingsPage();
          },
        ));
      },
    ));

    drawerListTiles.add(ListTile(
        leading: Icon(Icons.info),
        title: Text("About"),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) {
              return AboutPage();
            },
          ));
        }));

    List<Widget> scaffoldActions = [];

    if (_currentDrawerIndex != 3) {
      scaffoldActions.add(DropdownButtonHideUnderline(
        child: DropdownButton(
          value: _yearList.length > 0 ? _currentYear : null,
          items: _yearList.map((String year) {
            return DropdownMenuItem(
              child: Text(year, style: TextStyle(color: DynamicTheme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black)),
              value: year,
            );
          }).toList(),
          onChanged: (String year) {
            this.setState(() {
              this._currentYear = year;
            });
          },
          iconEnabledColor: Colors.black,
        ),
      ));
    }

    scaffoldActions.add(IconButton(
      icon: Icon(Icons.refresh),
      onPressed: () {
        this.setState(() {});
      },
    ));

    scaffoldActions.add(IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return SearchPage();
        }));
      },
    ));

    return Scaffold(
      appBar: AppBar(title: Text(widget.drawerItems[_currentDrawerIndex].title), actions: scaffoldActions),
      drawer: Drawer(
        child: ListView(
          children: drawerListTiles,
        ),
      ),
      body: _getDrawerItemFragment(_currentDrawerIndex),
    );
  }
}

class Fragment {
  void updateYear() {}
}
