import 'package:broomball_app/fragments/android/conference_fragment_android.dart';
import 'package:broomball_app/fragments/android/schedule_fragment_android.dart';
import 'package:broomball_app/fragments/android/teams_fragment_android.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../search_page.dart';

class MainPageAndroid extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageAndroidState();
  }
}

class MainPageAndroidState extends State<MainPageAndroid> {
  final BroomballWebScraper _broomballWebScraper = BroomballWebScraper();
  Future<BroomballMainPageData> _broomballData;

  ConferenceFragment _conferenceFragment;
  TeamsFragment _teamsFragment;
  ScheduleFragment _scheduleFragment;

  AppBar _appBar;
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
    _broomballData = _broomballWebScraper.run(_currentYear);

    _conferenceFragment = ConferenceFragment(
        year: _currentYear,
        broomballData: _broomballData,
      );

    _teamsFragment = TeamsFragment(
        year: _currentYear,
        broomballData: _broomballData,
      );

    _scheduleFragment = ScheduleFragment(
        year: _currentYear,
      );

    _fragments = <Widget> [
      _conferenceFragment,
      _teamsFragment,
      _scheduleFragment,
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedIndex == 0 || _selectedIndex == 1) {
      _appBar = AppBar(
          title: Text(_selectedIndex == 0 ? "Conferences" : "Teams"),
          actions: <Widget>[
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
        );
    }
    else {
      _appBar = null;
    }

    return Scaffold(
      appBar: _appBar,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text("Conferences"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text("Teams"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text("Schedule"),
          )
        ],
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
      ),
      body: _fragments[_selectedIndex],
    );
  }
}
