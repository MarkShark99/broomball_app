import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FavoritesPageState();
  }
}

class FavoritesPageState extends State<FavoritesPage> {
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
}
