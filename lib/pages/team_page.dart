import 'package:broomball_app/pages/player_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:broomball_app/util/app_data.dart';
import 'package:broomball_app/util/notifications.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

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

  FavoritesData _favoritesData;

  BroomballNotifications _broomballNotifications;

  String _captainDisplayName = "N/A";
  int _wins = 0;
  int _losses = 0;
  int _ties = 0;
  int _goals = 0;
  double _winPercentage = 0;
  double _averageGoals = 0;
  int _matchesPlayed = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    AppData().loadFavoritesData().then((favoritesData) {
      this._favoritesData = favoritesData;
    });
    super.initState();

    _broomballNotifications = BroomballNotifications();

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
            String name = parse(parse(team.name).body.text).documentElement.text;

            this._isFavorite = this._favoritesData.teams.containsKey("${team.name} (${team.seasonId})");

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
            _winPercentage = 0;
            _averageGoals = 0;
            _matchesPlayed = 0;

            for (TeamRosterPlayer teamRosterPlayer in team.roster) {
              if (teamRosterPlayer.id == team.captainPlayerId) {
                this._captainDisplayName = teamRosterPlayer.displayName;
                break;
              }
            }

            for (TeamScheduleMatch teamScheduleMatch in team.schedule) {
              if (teamScheduleMatch.played == "1") {
                _matchesPlayed++;

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

            _winPercentage = _wins / _matchesPlayed * 100;
            _averageGoals = _goals / _matchesPlayed;

            return DefaultTabController(
              length: 3,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(name),
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
                          if (this._isFavorite) {
                            _favoritesData.teams["${team.name} (${team.seasonId})"] = team.id;

                            DateFormat notificationDateFormat = DateFormat.jm();
                            // Schedule match notifications
                            for (int i = 0; i < team.schedule.length; i++) {
                              if (team.schedule[i].startTimeDateTime.difference(DateTime.now()).inMinutes >= 0) {
                                _broomballNotifications.scheduleNotification(team.id, team.schedule[i].startTimeDateTime.subtract(Duration(minutes: 30)), "${team.schedule[i].homeTeamName} vs. ${team.schedule[i].awayTeamName} - ${notificationDateFormat.format(team.schedule[i].startTimeDateTime)} - ${team.schedule[i].rinkName}");
                                print("Registered notification ${DateTime.now()} at ${team.schedule[i].startTimeDateTime.subtract(Duration(minutes: 30))}");
                              }
                            }
                          } else {
                            _favoritesData.teams.remove("${team.name} (${team.seasonId})");

                            _broomballNotifications.cancelNotificationsById(team.id);
                          }
                          AppData().writeFavoritesData(_favoritesData);
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
                    ListView(
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.people),
                                title: Text(name),
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
                        GridView.count(
                          crossAxisCount: 2,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          children: <Widget>[
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "$_wins - $_losses - $_ties",
                                    style: Theme.of(context).textTheme.headline,
                                  ),
                                  Text(
                                    "Win - Loss - Tie",
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("$_goals", style: Theme.of(context).textTheme.headline),
                                  Text(
                                    "Goals",
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("${_winPercentage.toInt()}%", style: Theme.of(context).textTheme.headline),
                                  Text(
                                    "Win Percentage",
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("${_averageGoals.toStringAsFixed(2)}", style: Theme.of(context).textTheme.headline),
                                  Text(
                                    "Average Goals/Game",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
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
                          String win = ((team.schedule[index].homeTeamName == team.name && int.parse(team.schedule[index].homeGoals) > int.parse(team.schedule[index].awayGoals)) || (team.schedule[index].awayTeamName == team.name && int.parse(team.schedule[index].awayGoals) > int.parse(team.schedule[index].homeGoals))) ? "W" : "L";
                          
                          return ListTile(
                            // leading: Text(team.schedule[index].played == "1" ? win : "U"),
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
    this._team = BroomballAPI().fetchTeam(widget.id);
  }
}
