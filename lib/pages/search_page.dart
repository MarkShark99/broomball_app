import 'package:broomball_app/pages/player_page.dart';
import 'package:broomball_app/pages/team_page.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';
import 'package:http/http.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  Future<List<SearchItem>> _searchResults;

  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    searchController.dispose();
    super.dispose();
  }

  // TODO: Fix Paul's weird code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search for teams and players",
          ),
          onSubmitted: (text) {
            this.setState(() {
              _searchResults = _search("${searchController.text}");
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              this.setState(() {
                _searchResults = _search("${searchController.text}");
              });
            },
          )
        ],
      ),
      body: Center(
        child: FutureBuilder(
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("Search for teams and players");
              case ConnectionState.waiting:
              case ConnectionState.active:
                return CircularProgressIndicator();
              case ConnectionState.done:
                List<SearchItem> searchItems = snapshot.data;

                return searchItems.isEmpty
                    ? Center(
                        child: Text("No results found"),
                      )
                    : ListView.separated(
                        itemCount: searchItems.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(searchItems[index].name),
                            subtitle: Text(searchItems[index].type),
                            onTap: () {
                              if (searchItems[index].type == "Player") {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PlayerPage(
                                        id: searchItems[index].id,
                                      );
                                    },
                                  ),
                                );
                              } else if (searchItems[index].type == "Team") {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return TeamPage(
                                        id: searchItems[index].id,
                                      );
                                    },
                                  ),
                                );
                              }
                            },
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider();
                        },
                      );
            }
            return null;
          },
          future: _searchResults,
        ),
      ),
    );
  }

  Future<List<SearchItem>> _search(String query) async {
    List<SearchItem> searchItems = <SearchItem>[];

    Map<String, String> data = {
      "term": query,
      "search": "Search",
    };

    // Map<String, String> headers = {
    //   "Origin": "https://www.broomball.mtu.edu",
    //   "Content-Type": "application/x-www-form-urlencoded",
    //   "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36",
    // };

    final Response response = await post(
      "https://www.broomball.mtu.edu/search/quick",
      body: data,
      // headers: headers,
    );

    if (response.statusCode == 200) {
      print("Loaded page");
      Document document = parse(response.body);
      List<Element> searchResults = document.querySelectorAll("#main_content_container > a");

      for (Element searchResult in searchResults) {
        String resultString = searchResult.text;
        String type = resultString.split(": ")[0];
        String name = resultString.split(": ")[1];
        String id = searchResult.attributes["href"].split("/").last;

        if (type == "Player" || type == "Team") {
          searchItems.add(SearchItem(
            type: type,
            name: name,
            id: id,
          ));
        }
      }

      return searchItems;
    }

    return null;
  }
}

enum SearchItemType {
  team,
  player,
}

class SearchItem {
  String type;
  String name;
  String id;

  SearchItem({@required this.type, @required this.name, @required this.id});
}
