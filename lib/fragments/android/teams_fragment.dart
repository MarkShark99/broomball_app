import 'package:broomball_app/pages/team_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';

class TeamsFragment extends StatefulWidget {
  final String year;
  final Future<BroomballMainPageData> broomballData;

  TeamsFragment({@required this.year, @required this.broomballData});

  @override
  State<StatefulWidget> createState() {
    return TeamsFragmentState();
  }
}

class TeamsFragmentState extends State<TeamsFragment> {
  final BroomballWebScraper _broomballWebScraper = BroomballWebScraper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return CircularProgressIndicator();
            case ConnectionState.done:
              BroomballMainPageData broomballData = snapshot.data;

              Map<String, String> teamIDMap = Map();
              List<String> teamNameList = <String>[];

              for (String teamID in broomballData.teams.keys.toList()) {
                teamIDMap[broomballData.teams[teamID]] = teamID;
                teamNameList.add(broomballData.teams[teamID]);
              }
              teamNameList.sort();

              return ListView.separated(
                itemCount: broomballData.teams.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      teamNameList[index],
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return TeamPage(
                            id: teamIDMap[teamNameList[index]],
                          );
                        },
                      ));
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              );
          }
          return null;
        },
        future: widget.broomballData,
      ),
    );
  }
}
