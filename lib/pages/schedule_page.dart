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
      });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd");

    if (_selectedDate.year <= 2003) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Schedule - " + DateFormat.yMMMd().format(_selectedDate)),
          automaticallyImplyLeading: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                _selectDate(context);
              },
            )
          ],
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

                for (String dayTime in data.times.keys.toList()) {
                  if (data.times[dayTime].rink1 != null && data.times[dayTime].rink1.played == "1") {
                    rink1Matches.add(ListTile(
                      title: Text("${data.times[dayTime].rink1.homeTeamName} vs. ${data.times[dayTime].rink1.awayTeamName}"),
                      subtitle: Text(dateFormat.format(DateTime.parse(dayTime))),
                    ));
                    rink1Matches.add(Divider());
                  }
                }

                if (rink1Matches.length > 0)
                  rink1Matches.removeLast();
                else
                  return Center(
                    child: Text("No match data for this date"),
                  );

                return ListView(
                  children: rink1Matches,
                );
            }
            return null;
          },
          future: BroomballAPI().fetchScheduleDay(dateFormat.format(_selectedDate)),
        ),
      );
    } else if (_selectedDate.year <= 2007) {
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Schedule - " + DateFormat.yMMMd().format(_selectedDate)),
            automaticallyImplyLeading: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  _selectDate(context);
                },
              )
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "East Rink",
                ),
                Tab(
                  text: "West Rink",
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

                  List<Widget> eastRinkMatches = <Widget>[];
                  List<Widget> westRinkMatches = <Widget>[];

                  for (String dayTime in data.times.keys.toList()) {
                    if (data.times[dayTime].east != null && data.times[dayTime].east.played == "1") {
                      eastRinkMatches.add(ListTile(
                        title: Text("${data.times[dayTime].east.homeTeamName} vs. ${data.times[dayTime].east.awayTeamName}"),
                        subtitle: Text(dateFormat.format(DateTime.parse(dayTime))),
                        trailing: Text("${data.times[dayTime].east.homeGoals} - ${data.times[dayTime].east.awayGoals}"),
                      ));
                      eastRinkMatches.add(Divider());
                    }

                    if (data.times[dayTime].west != null && data.times[dayTime].west.played == "1") {
                      westRinkMatches.add(ListTile(
                        title: Text("${data.times[dayTime].west.homeTeamName} vs. ${data.times[dayTime].west.awayTeamName}"),
                        subtitle: Text(dateFormat.format(DateTime.parse(dayTime))),
                        trailing: Text("${data.times[dayTime].west.homeGoals} - ${data.times[dayTime].west.awayGoals}"),
                      ));
                      westRinkMatches.add(Divider());
                    }
                  }

                  if (eastRinkMatches.length > 0)
                    eastRinkMatches.removeLast();
                  else
                    return Center(
                      child: Text("No match data for this date"),
                    );

                  if (westRinkMatches.length > 0)
                    westRinkMatches.removeLast();
                  else
                    return Center(
                      child: Text("No match data for this date"),
                    );

                  return TabBarView(
                    children: <Widget>[
                      Center(
                        child: ListView(
                          children: eastRinkMatches,
                        ),
                      ),
                      Center(
                        child: ListView(
                          children: westRinkMatches,
                        ),
                      ),
                    ],
                  );
              }
              return null;
            },
            future: BroomballAPI().fetchScheduleDay(dateFormat.format(_selectedDate)),
          ),
        ),
      );
    } else {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Schedule - " + DateFormat.yMMMd().format(_selectedDate)),
            automaticallyImplyLeading: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () {
                  _selectDate(context);
                },
              )
            ],
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "Black Rink",
                ),
                Tab(
                  text: "Silver Rink",
                ),
                Tab(
                  text: "Gold Rink",
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

                  List<Widget> blackRinkMatches = <Widget>[];
                  List<Widget> silverRinkMatches = <Widget>[];
                  List<Widget> goldRinkMatches = <Widget>[];

                  for (String dayTime in data.times.keys.toList()) {
                    if (data.times[dayTime].black != null && data.times[dayTime].black.played == "1") {
                      blackRinkMatches.add(ListTile(
                        title: Text("${data.times[dayTime].black.homeTeamName} vs. ${data.times[dayTime].black.awayTeamName}"),
                        subtitle: Text(dateFormat.format(DateTime.parse(dayTime))),
                        trailing: Text("${data.times[dayTime].black.homeGoals} - ${data.times[dayTime].black.awayGoals}"),
                      ));
                      blackRinkMatches.add(Divider());
                    }

                    if (data.times[dayTime].silver != null && data.times[dayTime].silver.played == "1") {
                      silverRinkMatches.add(ListTile(title: Text("${data.times[dayTime].silver.homeTeamName} vs. ${data.times[dayTime].silver.awayTeamName}"), subtitle: Text(dateFormat.format(DateTime.parse(dayTime))), trailing: Text("${data.times[dayTime].silver.homeGoals} - ${data.times[dayTime].silver.awayGoals}")));
                      silverRinkMatches.add(Divider());
                    }

                    if (data.times[dayTime].gold != null && data.times[dayTime].gold.played == "1") {
                      goldRinkMatches.add(ListTile(title: Text("${data.times[dayTime].gold.homeTeamName} vs. ${data.times[dayTime].gold.awayTeamName}"), subtitle: Text(dateFormat.format(DateTime.parse(dayTime))), trailing: Text("${data.times[dayTime].gold.homeGoals} - ${data.times[dayTime].gold.awayGoals}")));
                      goldRinkMatches.add(Divider());
                    }
                  }

                  if (blackRinkMatches.length > 0)
                    blackRinkMatches.removeLast();
                  else
                    return Center(
                      child: Text("No match data for this date"),
                    );

                  if (silverRinkMatches.length > 0)
                    silverRinkMatches.removeLast();
                  else
                    return Center(
                      child: Text("No match data for this date"),
                    );

                  if (goldRinkMatches.length > 0)
                    goldRinkMatches.removeLast();
                  else
                    return Center(
                      child: Text("No match data for this date"),
                    );

                  return TabBarView(
                    children: <Widget>[
                      Center(
                        child: ListView(
                          children: blackRinkMatches,
                        ),
                      ),
                      Center(
                        child: ListView(
                          children: silverRinkMatches,
                        ),
                      ),
                      Center(
                        child: ListView(
                          children: goldRinkMatches,
                        ),
                      ),
                    ],
                  );
              }
              return null;
            },
            future: BroomballAPI().fetchScheduleDay(dateFormat.format(_selectedDate)),
          ),
        ),
      );
    }
  }
}
