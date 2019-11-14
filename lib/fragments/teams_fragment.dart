import 'package:broomball_app/pages/team_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:broomball_app/util/util.dart';
import 'package:flutter/material.dart';
import 'dart:collection';

class TeamsFragment extends StatefulWidget {
  final String year;

  TeamsFragment({this.year});

  @override
  State<StatefulWidget> createState() {
    return TeamsFragmentState();
  }
}

class TeamsFragmentState extends State<TeamsFragment> {
  final BroomballData broomballData = BroomballData();
  Map<String, String> _teamIDPairMap = Map<String, String>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.year != null) {
      _teamIDPairMap = _getTeamIDPairMap();
    }

    List<String> teamNameList = _teamIDPairMap.keys.toList();
    teamNameList.sort();

    return Center(
      child: widget.year == null
          ? CircularProgressIndicator()
          : ListView.separated(
              itemCount: teamNameList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    teamNameList[index],
                  ),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TeamPage(
                            id: _teamIDPairMap[teamNameList[index]],
                          ))),
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
    );
  }

  /// Builds a list of all teams for the current year
  Map<String, String> _getTeamIDPairMap() {
    int conferenceCount = broomballData
        .jsonData["years"][widget.year]["conferences"].keys
        .toList()
        .length;
    String currentConference;
    int divisionCount;
    String currentDivision;
    int teamCount;

    Map<String, String> teamIDPairMap = Map<String, String>();


    for (int i = 0; i < conferenceCount; i++) {
      currentConference = broomballData
          .jsonData["years"][widget.year]["conferences"].keys
          .toList()[i];
      divisionCount = broomballData
          .jsonData["years"][widget.year]["conferences"][currentConference]
              ["divisions"]
          .keys
          .toList()
          .length;
      for (int j = 0; j < divisionCount; j++) {
        currentDivision = broomballData
            .jsonData["years"][widget.year]["conferences"][currentConference]
                ["divisions"]
            .keys
            .toList()[j];
        teamCount = broomballData
            .jsonData["years"][widget.year]["conferences"][currentConference]
                ["divisions"][currentDivision]["teamIDs"]
            .length;
        for (int k = 0; k < teamCount; k++) {
          String ID = broomballData.jsonData["years"][widget.year]["conferences"]
                  [currentConference]["divisions"][currentDivision]["teamIDs"][k];
          String team = broomballData.jsonData["teams"][ID]["teamName"];

          teamIDPairMap[team] = ID;
        }
      }
    }

    return teamIDPairMap;
  }
}