import 'package:broomball_app/pages/favorites_page.dart';
import 'package:broomball_app/pages/schedule_fragment.dart';
import 'package:broomball_app/pages/search_fragment.dart';
import 'package:broomball_app/pages/teams_fragment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'conference_fragment.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  ConferenceFragment _conferenceFragment;
  TeamsFragment _teamsFragment;
  ScheduleFragment _scheduleFragment;
  SearchFragment _searchFragment;
  FavoritesPage _favoritesPage;

  String _currentYear;

  List<String> _yearList = <String>[];

  List<Widget> _fragments;
  PlatformTabController _tabController;

  @override
  void initState() {
    super.initState();
    int yearOffset = DateTime.now().month == 12 ? 1 : 0;
    int currentYear = DateTime.now().year + yearOffset;
    _yearList = <String>[];

    for (int i = currentYear; i >= 2002; i--) {
      _yearList.add(i.toString());
    }

    _currentYear = currentYear.toString();

    _conferenceFragment = ConferenceFragment();

    _teamsFragment = TeamsFragment();

    _scheduleFragment = ScheduleFragment(
      year: _currentYear,
    );

    _searchFragment = SearchFragment();
    _favoritesPage = FavoritesPage();

    _fragments = <Widget>[
      _conferenceFragment,
      _teamsFragment,
      _scheduleFragment,
      // _searchFragment,
      _favoritesPage,
    ];

    _tabController = PlatformTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformTabScaffold(
      tabController: _tabController,
      // cupertino: (context, platform) => CupertinoTabScaffoldData(),
      // android: (context) => MaterialTabScaffoldData(),
      bodyBuilder: (context, index) => _fragments[index],
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            isMaterial(context) ? Icons.assignment : CupertinoIcons.collections,
          ),
          title: Text("Conferences"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            isMaterial(context) ? Icons.people : CupertinoIcons.person,
          ),
          title: Text("Teams"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            isMaterial(context) ? Icons.calendar_today : CupertinoIcons.clock,
            // color: Theme.of(context).iconTheme.color,
          ),
          title: Text("Schedule"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          icon: Icon(
            isMaterial(context) ? Icons.star_border : CupertinoIcons.heart,
            // color: Theme.of(context).iconTheme.color,
          ),
          title: Text("Favorites"),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
