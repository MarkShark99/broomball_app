import 'package:broomball_app/pages/team_page.dart';
import 'package:broomball_app/util/broomballdata.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  final String year;

  SchedulePage({this.year});

  @override
  State<StatefulWidget> createState() {
    return SchedulePageState();
  }
}

class SchedulePageState extends State<SchedulePage> {
  Future<ScheduleDay> _schedule;

  DateTime _selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2002, 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        _refresh();
      });
  }

  void _refresh() {
    _schedule = BroomballAPI().fetchScheduleDay(DateFormat("yyyy-MM-dd").format(_selectedDate));
  }

  @override
  void initState() {
    super.initState();
    _schedule = BroomballAPI().fetchScheduleDay(DateFormat("yyyy-MM-dd").format(_selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    List<Tab> tabs = <Tab>[];

    if (_selectedDate.year <= 2003) {
      tabs.add(Tab(text: "Rink 1"));
    } else if (_selectedDate.year <= 2007) {
      tabs.add(
        Tab(
          text: "East Rink",
        ),
      );
      tabs.add(
        Tab(
          text: "West Rink",
        ),
      );
    } else {
      tabs.add(
        Tab(
          text: "Black Rink",
        ),
      );
      tabs.add(
        Tab(
          text: "Silver Rink",
        ),
      );
      tabs.add(
        Tab(
          text: "Gold Rink",
        ),
      );
    }

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(DateFormat.yMMMd().format(_selectedDate)),
          automaticallyImplyLeading: true,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.arrow_left),
                onPressed: () {
                  this.setState(() {
                    _selectedDate = _selectedDate.subtract(Duration(days: 1));
                    _refresh();
                  });
                }),
            IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () {
                  this.setState(() {
                    _selectedDate = _selectedDate.add(Duration(days: 1));
                    _refresh();
                  });
                }),
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ],
          bottom: TabBar(
            tabs: tabs,
          ),
        ),
        body: FutureBuilder(
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                DateFormat dateFormat = new DateFormat("jm");
                ScheduleDay data = snapshot.data;

                if (data.times.isEmpty)
                  return Center(
                    child: Text("No match data for this date"),
                  );

                List<Widget> rink1Matches = <Widget>[];
                List<Widget> eastRinkMatches = <Widget>[];
                List<Widget> westRinkMatches = <Widget>[];
                List<Widget> blackRinkMatches = <Widget>[];
                List<Widget> silverRinkMatches = <Widget>[];
                List<Widget> goldRinkMatches = <Widget>[];

                List<String> dayTimes = data.times.keys.toList();

                for (int i = 0; i < dayTimes.length; i++) {
                  String dayTime = dayTimes[i];

                  if (data.times[dayTime].rink1 != null && data.times[dayTime].rink1.played == "1") {
                    rink1Matches.add(ListTile(
                      title: Text("${data.times[dayTime].rink1.homeTeamName} vs. ${data.times[dayTime].rink1.awayTeamName}"),
                      subtitle: Text(dateFormat.format(DateTime.parse(dayTime))),
                      trailing: Text("${data.times[dayTime].rink1.homeGoals} - ${data.times[dayTime].rink1.awayGoals}"),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text("More options"),
                                children: <Widget>[
                                  SimpleDialogOption(
                                      child: Text("View Home Team"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return TeamPage(
                                            id: data.times[dayTime].rink1.homeTeamId,
                                          );
                                        }));
                                      }),
                                  SimpleDialogOption(
                                      child: ListTile(title: Text("View Away Team")),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return TeamPage(
                                            id: data.times[dayTime].rink1.awayTeamId,
                                          );
                                        }));
                                      }),
                                ],
                              );
                            });
                      },
                    ));
                    rink1Matches.add(Divider());
                  }

                  if (data.times[dayTime].east != null && data.times[dayTime].east.played == "1") {
                    eastRinkMatches.add(ListTile(
                      title: Text("${data.times[dayTime].east.homeTeamName} vs. ${data.times[dayTime].east.awayTeamName}"),
                      subtitle: Text(dateFormat.format(DateTime.parse(dayTime))),
                      trailing: Text("${data.times[dayTime].east.homeGoals} - ${data.times[dayTime].east.awayGoals}"),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text("More options"),
                                children: <Widget>[
                                  SimpleDialogOption(
                                      child: Text("View Home Team"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return TeamPage(
                                            id: data.times[dayTime].east.homeTeamId,
                                          );
                                        }));
                                      }),
                                  SimpleDialogOption(
                                      child: Text("View Away Team"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return TeamPage(
                                            id: data.times[dayTime].east.awayTeamId,
                                          );
                                        }));
                                      }),
                                ],
                              );
                            });
                      },
                    ));
                    eastRinkMatches.add(Divider());
                  }

                  if (data.times[dayTime].west != null && data.times[dayTime].west.played == "1") {
                    westRinkMatches.add(ListTile(
                      title: Text("${data.times[dayTime].west.homeTeamName} vs. ${data.times[dayTime].west.awayTeamName}"),
                      subtitle: Text(dateFormat.format(DateTime.parse(dayTime))),
                      trailing: Text("${data.times[dayTime].west.homeGoals} - ${data.times[dayTime].west.awayGoals}"),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text("More options"),
                                children: <Widget>[
                                  SimpleDialogOption(
                                      child: ListTile(title: Text("View Home Team")),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return TeamPage(
                                            id: data.times[dayTime].west.homeTeamId,
                                          );
                                        }));
                                      }),
                                  SimpleDialogOption(
                                      child: ListTile(title: Text("View Away Team")),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return TeamPage(
                                            id: data.times[dayTime].west.awayTeamId,
                                          );
                                        }));
                                      }),
                                ],
                              );
                            });
                      },
                    ));
                    westRinkMatches.add(Divider());
                  }

                  if (data.times[dayTime].black != null && data.times[dayTime].black.played == "1") {
                    blackRinkMatches.add(ListTile(
                      title: Text("${data.times[dayTime].black.homeTeamName} vs. ${data.times[dayTime].black.awayTeamName}"),
                      subtitle: Text(dateFormat.format(DateTime.parse(dayTime))),
                      trailing: Text("${data.times[dayTime].black.homeGoals} - ${data.times[dayTime].black.awayGoals}"),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text("More options"),
                                children: <Widget>[
                                  SimpleDialogOption(
                                      child: ListTile(title: Text("View Home Team")),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return TeamPage(
                                            id: data.times[dayTime].black.homeTeamId,
                                          );
                                        }));
                                      }),
                                  SimpleDialogOption(
                                      child: ListTile(title: Text("View Away Team")),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return TeamPage(
                                            id: data.times[dayTime].black.awayTeamId,
                                          );
                                        }));
                                      }),
                                ],
                              );
                            });
                      },
                    ));
                    blackRinkMatches.add(Divider());
                  }

                  if (data.times[dayTime].silver != null && data.times[dayTime].silver.played == "1") {
                    silverRinkMatches.add(ListTile(
                      title: Text("${data.times[dayTime].silver.homeTeamName} vs. ${data.times[dayTime].silver.awayTeamName}"),
                      subtitle: Text(dateFormat.format(DateTime.parse(dayTime))),
                      trailing: Text("${data.times[dayTime].silver.homeGoals} - ${data.times[dayTime].silver.awayGoals}"),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text("More options"),
                                children: <Widget>[
                                  SimpleDialogOption(
                                      child: ListTile(title: Text("View Home Team")),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return TeamPage(
                                            id: data.times[dayTime].silver.homeTeamId,
                                          );
                                        }));
                                      }),
                                  SimpleDialogOption(
                                      child: ListTile(title: Text("View Away Team")),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return TeamPage(
                                            id: data.times[dayTime].silver.awayTeamId,
                                          );
                                        }));
                                      }),
                                ],
                              );
                            });
                      },
                    ));
                    silverRinkMatches.add(Divider());
                  }

                  if (data.times[dayTime].gold != null && data.times[dayTime].gold.played == "1") {
                    goldRinkMatches.add(ListTile(
                      title: Text("${data.times[dayTime].gold.homeTeamName} vs. ${data.times[dayTime].gold.awayTeamName}"),
                      subtitle: Text(dateFormat.format(DateTime.parse(dayTime))),
                      trailing: Text("${data.times[dayTime].gold.homeGoals} - ${data.times[dayTime].gold.awayGoals}"),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                title: Text("More options"),
                                children: <Widget>[
                                  SimpleDialogOption(
                                      child: ListTile(title: Text("View Home Team")),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return TeamPage(
                                            id: data.times[dayTime].gold.homeTeamId,
                                          );
                                        }));
                                      }),
                                  SimpleDialogOption(
                                      child: ListTile(title: Text("View Away Team")),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return TeamPage(
                                            id: data.times[dayTime].gold.awayTeamId,
                                          );
                                        }));
                                      }),
                                ],
                              );
                            });
                      },
                    ));
                    goldRinkMatches.add(Divider());
                  }
                }

                if (blackRinkMatches.length > 0) blackRinkMatches.removeLast();

                if (silverRinkMatches.length > 0) silverRinkMatches.removeLast();

                if (goldRinkMatches.length > 0) goldRinkMatches.removeLast();

                List<ListView> matchListViews = <ListView>[];
                if (_selectedDate.year <= 2003) {
                  matchListViews.add(ListView(
                    children: rink1Matches,
                  ));
                } else if (_selectedDate.year <= 2007) {
                  matchListViews.add(ListView(
                    children: eastRinkMatches,
                  ));
                  matchListViews.add(ListView(children: westRinkMatches));
                } else {
                  matchListViews.add(ListView(children: blackRinkMatches));
                  matchListViews.add(ListView(children: silverRinkMatches));
                  matchListViews.add(ListView(children: goldRinkMatches));
                }

                return TabBarView(
                  children: matchListViews,
                );
            }
            return null;
          },
          future: _schedule,
        ),
      ),
    );
  }
}