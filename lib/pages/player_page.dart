import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';
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
  int _saves = 0;

  bool _isFavorite = false;

  @override
  void initState() {
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
                Tab(text: "Matches"),
              ],
            ),
            actions: <Widget>[
            IconButton(
              icon: Icon(this._isFavorite ? Icons.star : Icons.star_border),
              onPressed: () => this.setState(() {
                this._isFavorite = !this._isFavorite;
              }),
            ),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () => _refresh(),
              )
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
                                ListTile(
                                    leading: Text("Goals"),
                                    title: Text("")),
                                Divider(),
                              ]),
                        )
                      ],
                    ),
                    Column(),
                  ],
                ),
        ));
  }

  void _refresh() {
    BroomballData()
        .fetchPlayer(widget.id)
        .then((Player player) => this.setState(() {
              _player = player;
            }));
  }
}
