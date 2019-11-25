import 'package:broomball_app/pages/teams_page.dart';
import 'package:flutter/material.dart';
import 'package:broomball_app/util/broomballdata.dart';

class DivisionPage extends StatelessWidget {
  final Conference conference;
  final BroomballData broomballData;

  DivisionPage({@required this.conference, @required this.broomballData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Divisions"),
      ),
      body: ListView.separated(
        itemCount: conference.divisions.length,
        itemBuilder: (context, index) {
          String text = conference.divisions.keys.toList()[index];
          return ListTile(
            title: Text(text),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return TeamsPage(
                    division: conference.divisions[text],
                    broomballData: this.broomballData,
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
}
