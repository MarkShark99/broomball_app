import 'package:flutter/material.dart';
import 'package:broomball_app/util/broomballdata.dart';

class TeamPage extends StatelessWidget {
  String year;
  String selectedConference;
  String selectedDivision;

  TeamPage(year, selectedConference, selectedDivision)
      : this.year = year,
        this.selectedConference = selectedConference,
        this.selectedDivision = selectedDivision;

  final BroomballData broomballData = BroomballData();

  @override
  Widget build(BuildContext context) {
    print("163392-------------" + broomballData.jsonData["teams"]["163392"]["teamName"]);
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
              String selection = broomballData.jsonData["teams"][broomballData.jsonData["years"][year]["conferences"][selectedConference]["divisions"][selectedDivision]["teamIDs"][index]]["teamName"];
              
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
