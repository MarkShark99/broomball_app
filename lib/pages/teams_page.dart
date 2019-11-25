import 'package:broomball_app/pages/team_page.dart';
import 'package:flutter/material.dart';
import 'package:broomball_app/util/broomballdata.dart';

class TeamsPage extends StatelessWidget {
  final Division division;
  final BroomballData broomballData;

  TeamsPage({@required this.division, @required this.broomballData});

  @override
  Widget build(BuildContext context) {
    Map<String, String> teamIDMap = Map();
    List<String> teamNameList = <String>[];

    for (String teamID in division.teamIDs) {
      teamIDMap[broomballData.teams[teamID]] = teamID;
      teamNameList.add(broomballData.teams[teamID]);
    }
    teamNameList.sort();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Teams"),
      ),
      body: ListView.separated(
        itemCount: teamIDMap.length,
        itemBuilder: (context, index) {
          String teamName = teamNameList[index];
          String teamID = teamIDMap[teamNameList[index]];

          return ListTile(
            title: Text(
              teamName,
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
               
                return TeamPage(id: teamID);
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
}
