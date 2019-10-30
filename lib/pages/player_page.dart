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
  Future<Player> player;

  @override
  void initState() {
    player = BroomballData().fetchPlayer(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Color(0xFFFFCD00),
          title: Text(widget.id)),
      body: Center(
        child: FutureBuilder<Player>(
            future: player,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.firstName);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // Unless data has loaded, display a progress indicator
              return CircularProgressIndicator();
            }),
      ),
    );
  }
}
