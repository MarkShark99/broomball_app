import 'package:broomball_app/pages/team_page.dart';
import 'package:flutter/material.dart';
import 'package:broomball_app/util/broomballdata.dart';

class TeamsPage extends StatelessWidget {
  final BroomballData broomballData = BroomballData();

  final String year;
  final String selectedConference;
  final String selectedDivision;

  TeamsPage({
    @required this.year,
    @required this.selectedConference,
    @required this.selectedDivision,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, String> teamIDMap = _fillIDTeamMap();
    List<String> teamNameList = teamIDMap.keys.toList();
    teamNameList.sort();

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: Text("Teams")),
      body: ListView.separated(
        itemCount: teamNameList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              teamNameList[index],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return TeamPage(id: teamIDMap[teamNameList[index]]);
              }));
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  Map<String, String> _fillIDTeamMap() {
    Map<String, String> teamIDMap = Map<String, String>();

    for (String id in broomballData.jsonData["years"][year]["conferences"][selectedConference]["divisions"][selectedDivision]["teamIDs"]) {
      teamIDMap[broomballData.jsonData["teams"][id]["teamName"]] = id;
    }

    return teamIDMap;
  }
}
