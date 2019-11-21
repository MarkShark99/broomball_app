import 'package:broomball_app/pages/teams_page.dart';
import 'package:flutter/material.dart';
import 'package:broomball_app/util/broomballdata.dart';

class DivisionPage extends StatelessWidget {
  final String selectedConference;
  final String year;

  final BroomballData broomballData = BroomballData();

  DivisionPage({this.selectedConference, this.year});

  @override
  Widget build(BuildContext context) {
    List<String> divisionList = _getDivisionList();

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: Text("Divisions")),
      body: ListView.separated(
        itemCount: divisionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(divisionList[index]),
            onTap: () {
              String selectedDivision = divisionList[index];
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return TeamsPage(
                    year: this.year,
                    selectedConference: this.selectedConference,
                    selectedDivision: selectedDivision,
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

  List<String> _getDivisionList() {
    List<String> divisionList = <String>[];
    
    for (String division in broomballData.jsonData["years"][this.year]["conferences"][this.selectedConference]["divisions"].keys.toList()) {
      divisionList.add(division);
    }

    divisionList.sort();

    return divisionList;
  }
}
