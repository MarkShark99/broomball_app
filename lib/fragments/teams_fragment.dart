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

  String currentYear = DateTime.now().year.toString();

  @override
  Widget build(BuildContext context) {
    // Build list of all teams in current year
    int conferencesAmount = broomballData.jsonData["years"][currentYear]["conferences"].keys.toList().length;
    String currentConference;
    int divisionsAmount;
    String currentDivision;
    int teamsAmount;
    List<String> currentTeamsList;

    List<String> teamsList;

    for(int i = 0; i < conferencesAmount; i++)
    {
      currentConference = broomballData.jsonData["years"][currentYear]["conferences"].keys.toList()[i];
      divisionsAmount = broomballData.jsonData["years"][currentYear]["conferences"][currentConference].keys.toList().length;
      for(int j = 0; j < divisionsAmount; j++)
      {
        currentDivision = broomballData.jsonData["years"][currentYear]["conferences"][currentConference]["divisions"].keys.toList()[j];
        teamsAmount = broomballData.jsonData["years"][currentYear]["conferences"][currentConference]["divisions"][currentDivision].keys.toList().length;
        for(int k = 0; k < teamsAmount; k++)
        {
          currentTeamsList = broomballData.jsonData["years"][currentYear]["conferences"][currentConference]["divisions"][currentDivision]["teamIDs"].keys.toList();
          for(int l = 0; l < currentTeamsList.length; l++)
          {
            teamsList.add(broomballData.jsonData["teams"][currentTeamsList[l]]["teamName"]);
          }
        }
      }
    }

    print("Amount of teams: " + teamsList.length.toString());
    print(teamsList);

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
