import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';
import 'package:broomball_app/util/app_data.dart';
import 'package:flutter/widgets.dart';

class PlayerPage extends StatefulWidget {
  final id;

  PlayerPage({@required this.id});

  @override
  State<StatefulWidget> createState() {
    return _PlayerPageState();
  }
}

class _PlayerPageState extends State<PlayerPage> {
  Future<Player> _player;

  FavoritesData _favoritesData;

  int _goals = 0;
  int _assists = 0;
  int _saves = 0;
  int _penaltyMinutes = 0;
  int _goalieMinutes = 0;
  int _gamesPlayed = 0;

  bool _isFavorite = false;

  @override
  void initState() {
    AppData().loadFavoritesData().then((favoritesData) {
      this._favoritesData = favoritesData;
    });

    super.initState();

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
            Player player = snapshot.data;
            this._isFavorite = this._favoritesData.players.containsKey("${player.displayName};${player.mtuId}");

            if (player == null) {
              return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                ),
                body: Center(
                  child: Text("Unable to load player information"),
                ),
              );
            }

            // Calculate stats
            _goals = 0;
            _assists = 0;
            _saves = 0;
            _penaltyMinutes = 0;
            _goalieMinutes = 0;
            _gamesPlayed = 0;

            for (PlayerStatsMatch match in player.stats) {
              _goals += int.parse(match.goals);
              _saves += int.parse(match.saves);
              _assists += int.parse(match.assists);
              _penaltyMinutes += int.parse(match.penaltyMinutes);
              _goalieMinutes += int.parse(match.goalieMinutes);
              _gamesPlayed += match.present == "1" ? 1 : 0;
            }

            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text(player.displayName),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(this._isFavorite ? Icons.star : Icons.star_border),
                    onPressed: () {
                      this.setState(() {
                        this._isFavorite = !this._isFavorite;
                      });

                      if (this._isFavorite) {
                        _favoritesData.players["${player.displayName};${player.mtuId}"] = player.id;
                      } else {
                        _favoritesData.players.remove("${player.displayName};${player.mtuId}");
                      }
                      AppData().writeFavoritesData(_favoritesData);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      _refresh();
                    },
                  ),
                ],
              ),
              body: ListView(
                children: <Widget>[
                  GridView.count(
                    crossAxisCount: 2,
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    children: <Widget>[
                      Card(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("$_saves", style: Theme.of(context).textTheme.headline),
                            Text(
                              "Saves",
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("$_assists", style: Theme.of(context).textTheme.headline),
                            Text(
                              "Assists",
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("$_goalieMinutes", style: Theme.of(context).textTheme.headline),
                            Text(
                              "${_goalieMinutes == 1 ? "Goalie Minute" : "Goalie Minutes"}",
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("$_penaltyMinutes", style: Theme.of(context).textTheme.headline),
                            Text(
                              "Penalty Minutes",
                            ),
                          ],
                        ),
                      ),
                      Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("$_gamesPlayed", style: Theme.of(context).textTheme.headline),
                            Text(
                              "Matches Played",
                            ),
                          ],
                        ),
                      ),
                    ],
                  )

                  // Card(
                  //   child: Column(
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: <Widget>[
                  //       ListTile(
                  //         title: Text("Statistics"),
                  //       ),
                  //       Divider(),
                  //       ListTile(
                  //         title: Text(_goals.toString()),
                  //         subtitle: Text(_goals == 1 ? "Goal" : "Goals"),
                  //       ),
                  //       Divider(),
                  //       ListTile(
                  //         title: Text(_saves.toString()),
                  //         subtitle: Text(_saves == 1 ? "Save" : "Saves"),
                  //       ),
                  //       Divider(),
                  //       ListTile(
                  //         title: Text(_assists.toString()),
                  //         subtitle: Text(_assists == 1 ? "Assist" : "Assists"),
                  //       ),
                  //       Divider(),
                  //       ListTile(
                  //         title: Text(_goalieMinutes.toString()),
                  //         subtitle: Text(_goalieMinutes == 1 ? "Goalie Minute" : "Goalie Minutes"),
                  //       ),
                  //       Divider(),
                  //       ListTile(
                  //         title: Text(_penaltyMinutes.toString()),
                  //         subtitle: Text(_penaltyMinutes == 1 ? "Penalty Minute" : "Penalty Minutes"),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Column(),
                ],
              ),
            );
        }
      },
      future: _player,
    );
  }

  void _refresh() {
    this._player = BroomballAPI().fetchPlayer(widget.id);
  }
}
