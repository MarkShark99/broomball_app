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
  Player _player;

  int _goals = 0;
  int _assists = 0;
  int _saves = 0;
  int _penaltyMinutes = 0;
  int _goalieMinutes = 0;

  bool _isFavorite = false;

  @override
  void initState() {
    AppData().loadFavoritesData().then((favoritesData) {
      _isFavorite = favoritesData.players.containsKey(widget.id);
    });

    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(_player == null ? "" : _player.displayName),
        actions: <Widget>[
          IconButton(
            icon: Icon(this._isFavorite ? Icons.star : Icons.star_border),
            onPressed: () {
              this.setState(() {
                this._isFavorite = !this._isFavorite;
              });
              AppData().loadFavoritesData().then((favoritesData) {
                if (this._isFavorite) {
                  favoritesData.players[_player.id] = _player.displayName;
                } else {
                  favoritesData.players.remove(_player.id);
                }
                AppData().writeFavoritesData(favoritesData);
              });
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
      body: _player == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text(_player.displayName),
                        subtitle: Text("Name"),
                      ),
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
                        title: Text(_goals.toString()),
                        subtitle: Text(_goals == 1 ? "Goal" : "Goals"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(_saves.toString()),
                        subtitle: Text(_saves == 1 ? "Save" : "Saves"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(_assists.toString()),
                        subtitle: Text(_assists == 1 ? "Assist" : "Assists"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(_goalieMinutes.toString()),
                        subtitle: Text(_goalieMinutes == 1 ? "Goalie Minute" : "Goalie Minutes"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text(_penaltyMinutes.toString()),
                        subtitle: Text(_penaltyMinutes == 1 ? "Penalty Minute" : "Penalty Minutes"),
                      ),
                    ],
                  ),
                ),
                Column(),
              ],
            ),
    );
  }

  void _refresh() {
    BroomballAPI().fetchPlayer(widget.id).then((Player player) {
      this.setState(() {
        _player = player;
        _goals = 0;
        _assists = 0;
        _saves = 0;
        _penaltyMinutes = 0;
        _goalieMinutes = 0;

        for (PlayerStatsMatch match in player.stats) {
          _goals += int.parse(match.goals);
          _saves += int.parse(match.saves);
          _assists += int.parse(match.assists);
          _penaltyMinutes += int.parse(match.penaltyMinutes);
          _goalieMinutes += int.parse(match.goalieMinutes);
        }
      });
    });
  }
}
