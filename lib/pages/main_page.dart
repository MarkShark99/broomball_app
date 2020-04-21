import 'package:broomball_app/fragments/android/conference_fragment.dart';
import 'package:broomball_app/fragments/android/teams_fragment.dart';
import 'package:broomball_app/pages/about_page.dart';
import 'package:broomball_app/pages/favorites_page.dart';
import 'package:broomball_app/pages/schedule_page.dart';
import 'package:broomball_app/pages/search_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:broomball_app/util/util.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'news_page.dart';

/// Class that contains fragments for Conferences, Teams, and Players
/// as well as a navigation drawer

class MainPage extends StatefulWidget {
  final drawerItems = <DrawerItem>[
    new DrawerItem(title: "Conferences", icon: Icons.assignment),
    new DrawerItem(title: "Teams", icon: Icons.people),
  ];

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  final BroomballWebScraper _broomballWebScraper = BroomballWebScraper();
  Future<BroomballMainPageData> _broomballData;

  int _currentDrawerIndex = 0;
  String _currentYear;

  bool darkModeSwitchChecked = false;

  List<String> _yearList = <String>[];

  @override
  void initState() {
    super.initState();

    int yearOffset = DateTime.now().month == 12 ? 1 : 0;
    int currentYear = DateTime.now().year + yearOffset;
    this._yearList = <String>[];

    for (int i = currentYear; i >= 2002; i--) {
      this._yearList.add(i.toString());
    }

    this._currentYear = currentYear.toString();
    this._broomballData = _broomballWebScraper.run(this._currentYear);
  }

  Widget _getDrawerItemFragment(int index) {
    switch (index) {
      case 0:
        return new ConferenceFragment(
          year: _currentYear,
          broomballData: _broomballData,
        );
      case 1:
        return new TeamsFragment(
          year: _currentYear,
          broomballData: _broomballData,
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

    drawerListTiles.add(
      DrawerHeader(
        child: null,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icon_foreground.png"),
          ),
          color: Theme.of(context).primaryColor,
        ),
      ),
    );

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
        leading: Icon(Icons.calendar_today),
        title: Text("Schedule"),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return SchedulePage();
            },
          ));
        }));

    // drawerListTiles.add(ListTile(
    //   leading: Icon(Icons.description),
    //   title: Text("News"),
    //   onTap: () {
    //     Navigator.of(context).pop();
    //     Navigator.of(context).push(MaterialPageRoute(
    //       builder: (context) {
    //         return NewsPage();
    //       },
    //     ));
    //   },
    // ));

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

    drawerListTiles.add(
      ListTile(
        title: Text("Night mode"),
        leading: Icon(Icons.brightness_4),
        trailing: Switch(
          activeColor: Theme.of(context).accentColor,
          value: Theme.of(context).brightness == Brightness.dark,
          onChanged: (bool value) {
            setState(() {
              darkModeSwitchChecked = value;
              DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark);
            });
          },
        ),
      ),
    );

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

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.drawerItems[_currentDrawerIndex].title}"),
        actions: <Widget>[
          // FlatButton(
          //   onPressed: () {
          //     showDialog(
          //       context: context,
          //       builder: (context) {
          //         return SimpleDialog(
          //           title: Text("Select a year"),
          //           children: _yearList.map((year) {
          //             return ListTile(
          //               title: Text(year),
          //               onTap: () {
          //                 Navigator.of(context).pop();
          //                 this.setState(() {
          //                   this._currentYear = year;
          //                   this._broomballData = this._broomballWebScraper.run(year);
          //                 });
          //               },
          //             );
          //           }).toList(),
          //         );
          //       },
          //     );
          //   },
          //   child: Text(_currentYear),
          // ),
          Center(
            child: Text("$_currentYear"),
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Text("Select a year"),
                    children: _yearList.map((year) {
                      return ListTile(
                        title: Text(year),
                        onTap: () {
                          Navigator.of(context).pop();
                          this.setState(() {
                            this._currentYear = year;
                            this._broomballData = this._broomballWebScraper.run(year);
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return SearchPage();
                  },
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              this.setState(() {
                _broomballData = _broomballWebScraper.run(this._currentYear);
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView(
                children: drawerListTiles,
              ),
            )
          ],
        ),
      ),
      body: _getDrawerItemFragment(_currentDrawerIndex),
    );
  }
}
