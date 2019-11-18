import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  Player _player;

  final searchController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search',
          ),
        ),
        actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () => _executeSearch(searchController.text),
              )
            ],
      ),
      body: Center(
        child: Text(_player == null ? "" : _player.displayName),
      ),
    );
  }

  void _executeSearch(String search) {
    BroomballData()
       .fetchSearch(search)
       .then((Player player) => this.setState(() {
              _player = player;
            }));
  }
}