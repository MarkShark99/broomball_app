import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';

class NewsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewsPageState();
  }
}

class NewsPageState extends State<NewsPage> {
  Future<News> _news;

  @override
  void initState() {
    super.initState();

    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );

          case ConnectionState.done:
            News news = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text("News"),
              ),
              body: ListView.builder(
                itemCount: news.entries.length,
                itemBuilder: (context, index) {
                  return Card(
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(16.0),
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(news.entries[index].subject, style: Theme.of(context).textTheme.headline),
                        Text(parse(parse(news.entries[index].body).body.text).documentElement.text),
                      ],
                    ),
                  );
                },
              ),
            );
        }
      },
      future: _news,
    );
  }

  void _refresh() {
    this._news = BroomballAPI().fetchNews();
  }
}
