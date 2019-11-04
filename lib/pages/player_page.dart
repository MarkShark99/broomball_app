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

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFFFFCD00),
        title: Text(_player == null ? "" : _player.displayName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _refresh(),
          )
        ],
      ),
      body: Center(
          child: _player == null
              ? CircularProgressIndicator()
              : ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text(_player.displayName),
                    )
                  ],
                )),
    );
  }

  void _refresh() {
    this.setState(() => _player = null);
    BroomballData()
        .fetchPlayer(widget.id)
        .then((Player player) => this.setState(() => _player = player));
  }
}
