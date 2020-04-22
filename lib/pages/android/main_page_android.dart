import 'package:broomball_app/fragments/android/conference_fragment_android.dart';
import 'package:broomball_app/fragments/android/schedule_fragment_android.dart';
import 'package:broomball_app/fragments/android/search_fragment_android.dart';
import 'package:broomball_app/fragments/android/teams_fragment_android.dart';
import 'package:broomball_app/pages/favorites_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class MainPageAndroid extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageAndroidState();
  }
}

class MainPageAndroidState extends State<MainPageAndroid> {
  

  ConferenceFragment _conferenceFragment;
  TeamsFragment _teamsFragment;
  ScheduleFragment _scheduleFragment;
  SearchFragmentAndroid _searchFragment;
  FavoritesPage _favoritesPage;

  int _selectedIndex = 0;
  String _currentYear;

  List<String> _yearList = <String>[];

  List<Widget> _fragments;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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

    _searchFragment = SearchFragmentAndroid();    
    _favoritesPage = FavoritesPage();

    _fragments = <Widget> [
      _conferenceFragment,
      _teamsFragment,
      _scheduleFragment,
      // _searchFragment,
      _favoritesPage,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: Theme.of(context).iconTheme,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, color: Theme.of(context).iconTheme.color),
            title: Text("Conferences", style: Theme.of(context).textTheme.body1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, color: Theme.of(context).iconTheme.color),
            title: Text("Teams", style: Theme.of(context).textTheme.body1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today, color: Theme.of(context).iconTheme.color),
            title: Text("Schedule", style: Theme.of(context).textTheme.body1),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
          //   title: Text("Search", style: Theme.of(context).textTheme.body1),
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border, color: Theme.of(context).iconTheme.color),
            title: Text("Favorites", style: Theme.of(context).textTheme.body1),
          ),
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
      body: _fragments[_selectedIndex],
    );
  }
}
