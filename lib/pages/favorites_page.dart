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
              ),
            ],
          ),
        ),
        body: _favoritesData == null
            ? CircularProgressIndicator()
            : TabBarView(
                children: <Widget>[
                  Center(
                    child: ListView.separated(
                      itemCount: _favoritesData.teams.length,
                      itemBuilder: (context, index) {
                        String name = _favoritesData.teams[_favoritesData.teams.keys.toList()[index]];
                        String id = _favoritesData.teams.keys.toList()[index];
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
                      itemCount: _favoritesData.players.length,
                      itemBuilder: (context, index) {
                        String name = _favoritesData.players[_favoritesData.players.keys.toList()[index]];
                        String id = _favoritesData.players.keys.toList()[index];
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
              ),
      ),
    );
  }

  void _refresh() {
    AppData().loadFavoritesData().then((favoritesData) {
      this.setState(() {
        _favoritesData = favoritesData;
      });
    });
  }
}
