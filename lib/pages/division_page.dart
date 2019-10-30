import 'package:flutter/material.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:broomball_app/pages/team_page.dart';

class DivisionPage extends StatelessWidget {
  String year;
  String selectedConference;

  DivisionPage(year, selectedConference) : this.year = year, this.selectedConference = selectedConference;

  final BroomballData broomballData = BroomballData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Color(0xFFFFCD00),
            title: Text("Divisions")),
        body: ListView.separated(
              itemCount: broomballData
                  .jsonData["years"][year]["conferences"][selectedConference]["divisions"].keys
                  .toList()
                  .length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(broomballData
                      .jsonData["years"][year]["conferences"][selectedConference]["divisions"].keys
                      .toList()[index]),
                  onTap: () {
                    String selection = broomballData.jsonData["years"][year]["conferences"][selectedConference]["divisions"].keys.toList()[index];
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TeamPage(year, selectedConference, selection)));
                  },
                );
              },
              
          separatorBuilder: (context, index) {
            return Divider();
          },
        ));
  }
}
