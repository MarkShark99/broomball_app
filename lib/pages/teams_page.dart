import 'package:broomball_app/pages/team_page.dart';
import 'package:flutter/material.dart';
import 'package:broomball_app/util/broomballdata.dart';

class TeamsPage extends StatelessWidget {
  final String year;
  final String selectedConference;
  final String selectedDivision;

  TeamsPage({@required this.year, @required this.selectedConference, @required this.selectedDivision});

  final BroomballData broomballData = BroomballData();
  
  Map<String, String> _teamIDMap = Map<String, String>();

  @override
  Widget build(BuildContext context) {
    _fillIDTeamMap();
    List<String> teamNameList = _teamIDMap.keys.toList();
    teamNameList.sort();

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("Teams")),
      body: ListView.separated(
        itemCount: teamNameList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              teamNameList[index],
              ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => TeamPage(
                  id: _teamIDMap[teamNameList[index]]
                  )
                )
              );
            },
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  void _fillIDTeamMap() {
    List<String> teamList = <String>[];

    for(String id in broomballData.jsonData["years"][year]["conferences"][selectedConference]["divisions"][selectedDivision]["teamIDs"])
    {
      _teamIDMap[broomballData.jsonData["teams"][id]["teamName"]] = id;
    }
  }
}
