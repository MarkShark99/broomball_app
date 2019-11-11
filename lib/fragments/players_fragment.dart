import 'dart:convert';

import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';

class PlayersFragment extends StatefulWidget {
  final String id;
  PlayersFragment({this.id});

  @override
  State<StatefulWidget> createState() {
    return PlayersFragmentState();
  }

}

class PlayersFragmentState extends State<PlayersFragment> {

  final BroomballData broomballData = BroomballData();
  final PlayersFragmentState playerState = PlayersFragmentState();
  Map playerJSONData;

  Future<void> readPlayerFile() async {

      final file = broomballData.localFilePath;

      // Read the file.
      String contents = await file.readAsString();
      playerJSONData = jsonDecode(contents);

  }

  playerState.readPlayerFile();

  @override
   Widget build(BuildContext context) {
    return Center(
      child: widget.id == null
          ? CircularProgressIndicator()
          : ListView.separated(
              itemCount: playerJSONData["teams"].keys.toList().length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    playerJSONData["teams"][playerJSONData["teams"].keys
                        .toList()[index]
                        .toString()]["teamName"],
                  ),
                  onTap: () {},
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
    );
  }
}

