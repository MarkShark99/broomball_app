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
  final BroomballData broomballData = BroomballData();

  @override
  Widget build(BuildContext context) {
    // Build list of all teams in current year
    int conferencesAmount = broomballData
        .jsonData["years"][widget.year]["conferences"].keys
        .toList()
        .length;
    String currentConference;
    int divisionsAmount;
    String currentDivision;
    int teamsAmount;

    List<String> teamsList = <String>[];

    for (int i = 0; i < conferencesAmount; i++) {
      currentConference = broomballData
          .jsonData["years"][widget.year]["conferences"].keys
          .toList()[i];
      divisionsAmount = broomballData
          .jsonData["years"][widget.year]["conferences"][currentConference]
              ["divisions"]
          .keys
          .toList()
          .length;
      for (int j = 0; j < divisionsAmount; j++) {
        currentDivision = broomballData
            .jsonData["years"][widget.year]["conferences"][currentConference]
                ["divisions"]
            .keys
            .toList()[j];
        teamsAmount = broomballData
            .jsonData["years"][widget.year]["conferences"][currentConference]
                ["divisions"][currentDivision]["teamIDs"]
            .length;
        for (int k = 0; k < teamsAmount; k++) {
          String team = broomballData.jsonData["teams"][
              broomballData.jsonData["years"][widget.year]["conferences"]
                      [currentConference]["divisions"][currentDivision]
                  ["teamIDs"][k]]["teamName"];
          teamsList.add(team);
        }
      }
    }

    return Center(
      child: widget.year == null
          ? CircularProgressIndicator()
          : ListView.separated(
              itemCount: teamsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    teamsList[index],
                  ),
                  onTap: () {},
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
    );
  }
}
