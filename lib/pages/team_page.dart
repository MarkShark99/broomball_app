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
  String _captainDisplayName = "";

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_team == null ? "" : _team.name),
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => _refresh(),
            ),
          ],
        ),
        body: _team == null
            ? Center(child: CircularProgressIndicator())
            : TabBarView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.people),
                              title: Text(_team.name),
                              subtitle: Text("Name"),
                            ),
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.calendar_today),
                              title: Text(_team.seasonId),
                              subtitle: Text("Year"),
                            ),
                            Divider(),
                            ListTile(
                                leading: Icon(Icons.person),
                                title: Text(this._captainDisplayName),
                                subtitle: Text("Captain")),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: ListView.separated(
                      itemCount: _team.roster.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(_team.roster[index].displayName),
                            subtitle:
                                _team.roster[index].id == _team.captainPlayerId
                                    ? Text("Captain")
                                    : null);
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  ),
                  Center(
                    child: Text("Schedule"),
                  ),
                ],
              ),
      ),
    );
  }

  void _refresh() {
    // this.setState(() => _team = null);
    BroomballData().fetchTeam(widget.id).then((Team team) => this.setState(() {
          for (TeamRosterPlayer teamRosterPlayer in team.roster)
          {
            if (teamRosterPlayer.id == team.captainPlayerId)
            {
              this._captainDisplayName = teamRosterPlayer.displayName;
              break;
            }
          }
      
          _team = team;    
        }));
  }
}
