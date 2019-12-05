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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(_player == null ? "" : _player.displayName),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Info",
              ),
              Tab(
                text: "Matches",
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
            : TabBarView(
                children: <Widget>[
                  Column(
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
                            Divider(),
                            ListTile(
                              leading: Icon(Icons.calendar_today),
                              title: Text(""),
                              subtitle: Text("Years active"),
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
                            ListTile(leading: Text("Goals"), title: Text(_goals.toString())),
                            Divider(),
                            ListTile(leading: Text("Saves"), title: Text(_saves.toString())),
                            Divider(),
                            ListTile(leading: Text("Assists"), title: Text(_assists.toString())),
                            Divider(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(),
                ],
              ),
      ),
    );
  }

  void _refresh() {
    BroomballAPI().fetchPlayer(widget.id).then((Player player) {
      this.setState(() {
        _player = player;
        for (PlayerStatsMatch match in player.stats) {
          _goals += int.parse(match.goals);
          _saves += int.parse(match.saves);
          _assists += int.parse(match.assists);
        }
      });
    });
  }
}
