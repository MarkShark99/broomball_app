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
  List<String> _teamList;

  @override
  void initState()
  {
    super.initState();
    _teamList = _getTeamList();
  }

  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.star_border;
    bool isFavorite = false;
    return Center(
      child: widget.year == null
          ? CircularProgressIndicator()
          : ListView.separated(
              itemCount: _teamList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _teamList[index],
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

  List<String> _getTeamList()
  {
    // Build list of all teams in current year
    int conferenceCount = broomballData
        .jsonData["years"][widget.year]["conferences"].keys
        .toList()
        .length;
    String currentConference;
    int divisionCount;
    String currentDivision;
    int teamCount;

    List<String> teamList = <String>[];

    for (int i = 0; i < conferenceCount; i++) {
      currentConference = broomballData
          .jsonData["years"][widget.year]["conferences"].keys
          .toList()[i];
      divisionCount = broomballData
          .jsonData["years"][widget.year]["conferences"][currentConference]
              ["divisions"]
          .keys
          .toList()
          .length;
      for (int j = 0; j < divisionCount; j++) {
        currentDivision = broomballData
            .jsonData["years"][widget.year]["conferences"][currentConference]
                ["divisions"]
            .keys
            .toList()[j];
        teamCount = broomballData
            .jsonData["years"][widget.year]["conferences"][currentConference]
                ["divisions"][currentDivision]["teamIDs"]
            .length;
        for (int k = 0; k < teamCount; k++) {
          String team = broomballData.jsonData["teams"][
              broomballData.jsonData["years"][widget.year]["conferences"]
                      [currentConference]["divisions"][currentDivision]
                  ["teamIDs"][k]]["teamName"];
          teamList.add(team);
        }
      }
    }

    return teamList;
  }
}
