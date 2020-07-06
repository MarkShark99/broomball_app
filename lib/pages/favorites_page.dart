import 'package:broomball_app/pages/player_page.dart';
import 'package:broomball_app/pages/search_fragment.dart';
import 'package:broomball_app/pages/settings_page.dart';
import 'package:broomball_app/pages/team_page.dart';
import 'package:flutter/material.dart';
import 'package:broomball_app/util/app_data.dart';
import 'package:html/parser.dart';

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
          // automaticallyImplyLeading: true,
          title: Text("Favorites"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SearchFragment();
                    },
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return SettingsPage();
                  })
                );
              }
            )
          ],
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

                List<String> teamNameList = favoritesData.teams.keys.toList();
                teamNameList.sort();

                List<String> playerNameList =
                    favoritesData.players.keys.toList();
                playerNameList.sort();

                return TabBarView(
                  children: <Widget>[
                    Center(
                      child: favoritesData.teams.isEmpty
                          ? Center(
                              child: Text("No favorite teams found"),
                            )
                          : ListView.separated(
                              itemCount: favoritesData.teams.length,
                              itemBuilder: (context, index) {
                                String name =
                                    parse(parse(teamNameList[index]).body.text)
                                        .documentElement
                                        .text;
                                String id = favoritesData.teams[name];
                                return ListTile(
                                  title: Text(name),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
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
                      child: favoritesData.players.isEmpty
                          ? Center(child: Text("No favorite players found"))
                          : ListView.separated(
                              itemCount: favoritesData.players.length,
                              itemBuilder: (context, index) {
                                String name = playerNameList[index];
                                String id = favoritesData.players[name];
                                return ListTile(
                                  title: Text(name.split(";")[0]),
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
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
