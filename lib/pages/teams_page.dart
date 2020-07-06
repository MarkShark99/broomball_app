import 'package:broomball_app/pages/team_page.dart';
import 'package:flutter/material.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class TeamsPage extends StatelessWidget {
  final Division division;
  final BroomballMainPageData broomballData;

  TeamsPage({@required this.division, @required this.broomballData});

  @override
  Widget build(BuildContext context) {
    Map<String, String> teamIDMap = Map();
    List<String> teamNameList = <String>[];

    for (String teamID in division.teamIDs) {
      teamIDMap[broomballData.teams[teamID]] = teamID;
      teamNameList.add(broomballData.teams[teamID]);
    }
    // teamNameList.sort();

    int rank = 0;
    int previousPoints;

    return Material(
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          automaticallyImplyLeading: true,
          title: Text("Teams"),
        ),
        body: ListView.separated(
          itemCount: division.teamIDs.length,
          itemBuilder: (context, index) {
            // String teamName = teamNameList[index];
            // String teamID = teamIDMap[teamNameList[index]];

            String teamID = division.teamIDs.toList()[index].split(";")[0];
            String teamName = broomballData.teams[teamID];
            int points =
                int.parse(division.teamIDs.toList()[index].split(";")[1]);

            if (points != previousPoints) {
              rank++;
            }

            previousPoints = points;

            return ListTile(
              title: Text(
                teamName,
              ),
              subtitle: Text("$points points"),
              trailing: Text("#$rank"),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TeamPage(id: teamID);
                }));
              },
            );
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      ),
    );
  }
}
