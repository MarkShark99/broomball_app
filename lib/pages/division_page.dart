import 'package:flutter/material.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:broomball_app/pages/team_page.dart';

class DivisionPage extends StatelessWidget {
  final String selectedConference;
  final String year;

  final BroomballData broomballData = BroomballData();

  DivisionPage({this.selectedConference, this.year});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xFFFFCD00),
          title: Text("Divisions")),
      body: ListView.separated(
        itemCount: broomballData
            .jsonData["years"][year]["conferences"][selectedConference]
                ["divisions"]
            .keys
            .toList()
            .length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(broomballData
                .jsonData["years"][year]["conferences"][selectedConference]
                    ["divisions"]
                .keys
                .toList()[index]),
            onTap: () {
              String selectedTeam = broomballData
                  .jsonData["years"][year]["conferences"][selectedConference]
                      ["divisions"]
                  .keys
                  .toList()[index];
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TeamPage(year, selectedConference, selectedTeam)));
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
