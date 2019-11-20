import 'package:flutter/material.dart';
import 'package:broomball_app/util/app_data.dart';

class FavoritesPage extends StatefulWidget {

  final String id;

  FavoritesPage({@required this.id});

  @override
  State<StatefulWidget> createState() {
    return FavoritesPageState();
  }
}

class FavoritesPageState extends State<FavoritesPage> {

  Map _playerData;

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
          title: Text("Favorites"),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: "Teams"
              ),
              Tab(
                text: "Players",
              )
            ],
          ),
        )
      )
    );
  }

  void _refresh() {
    AppData()
        .loadFavoritesData();

    _playerData = AppData().favoritesData;

  }

}
