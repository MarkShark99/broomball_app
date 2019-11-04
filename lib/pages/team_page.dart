import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';

class TeamPage extends StatefulWidget {
  final String id;

  TeamPage({@required this.id});

  @override
  State<StatefulWidget> createState() {
    return TeamPageState();
  }
}

class TeamPageState extends State<TeamPage> {
  Team _team;
  
  @override
  Widget build(BuildContext context) {
    
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Team Page"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Info",
              ),
              Tab(
                text: "Players",
              ),
              Tab(text: "Schedule"),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Text("Info"),
            ),
            Center(
              child: Text("Players"),
            ),
            Center(
              child: Text("Schedule"),
            ),
          ],
        ),
      ),
    );
  }
}
