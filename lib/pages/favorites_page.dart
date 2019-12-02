import 'package:broomball_app/pages/player_page.dart';
import 'package:broomball_app/pages/team_page.dart';
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
  @override
  void initState() {
    super.initState();
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
              ),
            ],
          ),
        ),
        body: FutureBuilder(
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return CircularProgressIndicator();
              case ConnectionState.done:
                FavoritesData favoritesData = snapshot.data;

                return TabBarView(
                  children: <Widget>[
                    Center(
                      child: ListView.separated(
                        itemCount: favoritesData.teams.length,
                        itemBuilder: (context, index) {
                          String name = favoritesData.teams[favoritesData.teams.keys.toList()[index]];
                          String id = favoritesData.teams.keys.toList()[index];
                          return ListTile(
                            title: Text(name),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return TeamPage(id: id);
                                },
                              ));
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      ),
                    ),
                    Center(
                      child: ListView.separated(
                        itemCount: favoritesData.players.length,
                        itemBuilder: (context, index) {
                          String name = favoritesData.players[favoritesData.players.keys.toList()[index]];
                          String id = favoritesData.players.keys.toList()[index];
                          return ListTile(
                            title: Text(name),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) {
                                  return PlayerPage(id: id);
                                },
                              ));
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      ),
                    ),
                  ],
                );
            }
            return null;
          },
          future: AppData().loadFavoritesData(),
        ),
      ),
    );
  }
}