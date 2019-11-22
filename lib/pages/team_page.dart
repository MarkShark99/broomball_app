import 'package:broomball_app/pages/player_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:broomball_app/util/app_data.dart';
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
  int _wins = 0;
  int _losses = 0;
  int _ties = 0;
  int _goals = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    AppData().loadFavoritesData().then((favoritesData) {
      _isFavorite = favoritesData.teams.containsKey(widget.id);
    });
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
              Tab(
                text: "Schedule",
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(this._isFavorite ? Icons.star : Icons.star_border),
                onPressed: () {
                  this.setState(() {
                    this._isFavorite = !this._isFavorite;
                  });
                  AppData().loadFavoritesData().then((favoritesData) {
                    if (this._isFavorite) {
                      favoritesData.teams[_team.id] = _team.name;
                    } else {
                      favoritesData.teams.remove(_team.id);
                    }
                    AppData().writeFavoritesData(favoritesData);
                  });
                }),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _refresh();
              },
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
                              subtitle: Text("Year played"),
                            ),
                            Divider(),
                            ListTile(leading: Icon(Icons.person), title: Text(this._captainDisplayName), subtitle: Text("Captain")),
                            // Divider(),
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text("Statistics"),
                            ),
                            Divider(),
                            ListTile(
                              leading: Text("Record"),
                              title: Text(_wins.toString() + " - " + _losses.toString() + " - " + _ties.toString()),
                            ),
                            Divider(),
                            ListTile(
                              leading: Text("Goals"),
                              title: Text(_goals.toString()),
                            )
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
                          subtitle: _team.roster[index].id == _team.captainPlayerId ? Text("Captain") : null,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                              return PlayerPage(
                                id: _team.roster[index].id,
                              );
                            }));
                          },
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  ),
                  Center(
                    child: ListView.separated(
                      itemCount: _team.schedule.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_team.schedule[index].homeTeamName + " vs. " + _team.schedule[index].awayTeamName),
                          subtitle: Text(_team.schedule[index].startTime + " - " + _team.schedule[index].rinkName),
                          trailing: Text(_team.schedule[index].homeGoals.toString() + " - " + _team.schedule[index].awayGoals.toString()),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _refresh() {
    BroomballAPI().fetchTeam(widget.id).then((Team team) {
      _wins = 0;
      _losses = 0;
      _ties = 0;
      _goals = 0;

      for (TeamRosterPlayer teamRosterPlayer in team.roster) {
        if (teamRosterPlayer.id == team.captainPlayerId) {
          this._captainDisplayName = teamRosterPlayer.displayName;
          break;
        }
      }

      for (TeamScheduleMatch teamScheduleMatch in team.schedule) {
        if (teamScheduleMatch.homeGoals == teamScheduleMatch.awayGoals) {
          _goals += int.parse(teamScheduleMatch.homeGoals);
          _ties++;
        } else if (widget.id == teamScheduleMatch.homeTeamId) {
          _goals += int.parse(teamScheduleMatch.homeGoals);

          if (int.parse(teamScheduleMatch.homeGoals) > int.parse(teamScheduleMatch.awayGoals)) {
            // One of the two teams must have a win
            _wins++;
          } else {
            _losses++;
          }
        } else if (widget.id == teamScheduleMatch.awayTeamId) {
          _goals += int.parse(teamScheduleMatch.awayGoals);

          if (int.parse(teamScheduleMatch.awayGoals) > int.parse(teamScheduleMatch.homeGoals)) {
            _wins++;
          } else {
            _losses++;
          }
        }
      }

      this.setState(() {
        _team = team;
      });
    });
  }
}
