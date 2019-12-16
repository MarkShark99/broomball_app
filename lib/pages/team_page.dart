import 'package:broomball_app/pages/player_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:broomball_app/util/app_data.dart';
import 'package:broomball_app/util/notifications.dart';
import 'package:flutter/material.dart';

// TODO: Fix bug with favorites lookup

class TeamPage extends StatefulWidget {
  final String id;

  TeamPage({@required this.id});

  @override
  State<StatefulWidget> createState() {
    return TeamPageState();
  }
}

class TeamPageState extends State<TeamPage> {
  Future<Team> _team;

  BroomballNotifications _broomballNotifications;

  String _captainDisplayName = "N/A";
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

    _broomballNotifications = BroomballNotifications(context: context);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          case ConnectionState.done:
            Team team = snapshot.data;

            if (team == null) {
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                ),
                body: Center(
                  child: Text("Unable to load team information"),
                ),
              );
            }

            // Calculate stats
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
              if (teamScheduleMatch.played == "1") {
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
            }

            return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(team.name),
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
                              favoritesData.teams["${team.name} (${team.seasonId})"] = team.id;

                              // Schedule match notifications
                              for (int i = 0; i < team.schedule.length; i++) {
                                _broomballNotifications.scheduleNotification(team.id, team.schedule[i].startTimeDateTime.subtract(Duration(minutes: 30)), "${team.schedule[i].homeTeamName} vs. ${team.schedule[i].awayTeamName} - ${team.schedule[i].startTime} - ${team.schedule[i].rinkName}");
                                // print("Scheduled match: $i");
                              }

                              // _broomballNotifications.scheduleNotification(team.id, DateTime.now().add(Duration(seconds: 3)), "X vs. Y");
                              // print("Scheduling notification");
                            } else {
                              favoritesData.teams.remove(team.id);

                              _broomballNotifications.cancelNotificationsById(team.id);
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
                body: TabBarView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.people),
                                title: Text(team.name),
                                subtitle: Text("Name"),
                              ),
                              Divider(),
                              ListTile(
                                leading: Icon(Icons.calendar_today),
                                title: Text(team.seasonId),
                                subtitle: Text("Year played"),
                              ),
                              Divider(),
                              ListTile(
                                leading: Icon(Icons.person),
                                title: Text(this._captainDisplayName),
                                subtitle: Text("Captain"),
                              ),
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
                        itemCount: team.roster.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(team.roster[index].displayName),
                            subtitle: team.roster[index].id == team.captainPlayerId ? Text("Captain") : null,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return PlayerPage(
                                  id: team.roster[index].id,
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
                        itemCount: team.schedule.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text("${team.schedule[index].homeTeamName} vs. ${team.schedule[index].awayTeamName}"),
                            subtitle: Text("${team.schedule[index].startTime} - ${team.schedule[index].rinkName}"),
                            trailing: team.schedule[index].played == "1" ? Text("${team.schedule[index].homeGoals.toString()} - ${team.schedule[index].awayGoals.toString()}") : Text("Unplayed"),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    if (widget.id == team.schedule[index].homeTeamId) {
                                      return TeamPage(
                                        id: team.schedule[index].awayTeamId,
                                      );
                                    } else {
                                      return TeamPage(
                                        id: team.schedule[index].homeTeamId,
                                      );
                                    }
                                  },
                                ),
                              );
                            },
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
      },
      future: _team,
    );
  }

  void _refresh() {
    _team = BroomballAPI().fetchTeam(widget.id);
  }
}
