import 'package:broomball_app/pages/team_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';

class TeamsFragment extends StatefulWidget {
  final String year;

  TeamsFragment({this.year});

  @override
  State<StatefulWidget> createState() {
    return TeamsFragmentState();
  }
}

class TeamsFragmentState extends State<TeamsFragment> {
  final BroomballAPI _broomballAPI = BroomballAPI();

  Map<String, String> _teamIDMap = Map<String, String>();

  @override
  Widget build(BuildContext context) {
    // This will end up populating the team list once the year gets loaded in
    if (widget.year != null) {
      _fillTeamIDMap();
    }

    List<String> teamNameList = _teamIDMap.keys.toList();
    teamNameList.sort();

    if (widget.year == null || _teamIDMap.keys.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Center(
      child: ListView.separated(
        itemCount: teamNameList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              teamNameList[index],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return TeamPage(
                    id: _teamIDMap[teamNameList[index]],
                  );
                },
              ));
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  /// Builds a list of all teams for the current year
  void _fillTeamIDMap() {
    for (String conference in _broomballAPI.jsonData["years"][widget.year]["conferences"].keys.toList()) {
      for (String division in _broomballAPI.jsonData["years"][widget.year]["conferences"][conference]["divisions"].keys.toList()) {
        for (String id in _broomballAPI.jsonData["years"][widget.year]["conferences"][conference]["divisions"][division]["teamIDs"]) {
          _teamIDMap[_broomballAPI.jsonData["teams"][id]["teamName"]] = id;
        }
      }
    }
  }
}
