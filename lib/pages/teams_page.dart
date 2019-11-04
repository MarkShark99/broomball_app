import 'package:broomball_app/pages/team_page.dart';
import 'package:flutter/material.dart';
import 'package:broomball_app/util/broomballdata.dart';

class TeamsPage extends StatelessWidget {
  final String year;
  final String selectedConference;
  final String selectedDivision;

  TeamsPage({@required this.year, @required this.selectedConference, @required this.selectedDivision});

  final BroomballData broomballData = BroomballData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xFFFFCD00),
          title: Text("Teams")),
      body: ListView.separated(
        itemCount: broomballData
            .jsonData["years"][year]["conferences"][selectedConference]
                ["divisions"][selectedDivision]["teamIDs"]
            .length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              broomballData.jsonData["teams"][broomballData.jsonData["years"][year]["conferences"][selectedConference]["divisions"][selectedDivision]["teamIDs"][index]]["teamName"]
              ),
            onTap: () {
              String selectedTeam = broomballData.jsonData["teams"][broomballData.jsonData["years"][year]["conferences"][selectedConference]["divisions"][selectedDivision]["teamIDs"][index]]["teamName"];
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TeamPage(id: selectedTeam)));
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
