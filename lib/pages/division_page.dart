import 'package:broomball_app/pages/teams_page.dart';
import 'package:flutter/material.dart';
import 'package:broomball_app/util/broomballdata.dart';

class DivisionPage extends StatelessWidget {
  final String selectedConference;
  final String year;

  final BroomballData broomballData = BroomballData();
  List<String> _divisionList = <String>[];

  DivisionPage({this.selectedConference, this.year});

  @override
  Widget build(BuildContext context) {
    _divisionList = _getDivisionList();

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: Text("Divisions")),
      body: ListView.separated(
        itemCount: _divisionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_divisionList[index]),
            onTap: () {
              String selectedDivision = _divisionList[index];
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TeamsPage(
                        year: this.year,
                        selectedConference: this.selectedConference,
                        selectedDivision: selectedDivision,
                      )));
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
