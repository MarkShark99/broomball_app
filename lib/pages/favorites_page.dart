import 'package:flutter/material.dart';
import 'package:broomball_app/util/app_data.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage();

  @override
  State<StatefulWidget> createState() {
    return FavoritesPageState();
  }
}

class FavoritesPageState extends State<FavoritesPage> {
  FavoritesData _favoritesData;

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
                  text: "Teams",
                ),
                Tab(
                  text: "Players",
                )
              ],
            ),
          ),
          body: _favoritesData == null
              ? CircularProgressIndicator()
              : TabBarView(
                  children: <Widget>[
                    Column(),
                    Column()
                  ],
                ),
        ));
  }

  void _refresh() {
    AppData().loadFavoritesData().then((favoritesData) => this.setState(() => _favoritesData = favoritesData));
  }
}
