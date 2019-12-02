import 'dart:convert';
import 'package:flutter/material.dart' hide Element;
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class BroomballData {
  String year;
  Map<String, Conference> conferences;
  Map<String, String> teams;

  BroomballData()
      : year = "",
        conferences = Map<String, Conference>(),
        teams = Map<String, String>();
}

class Conference {
  Map<String, Division> divisions;
  Conference() : this.divisions = Map<String, Division>();
}

class Division {
  Set<String> teamIDs;
  Division() : this.teamIDs = Set<String>();
}

class BroomballWebScraper {
  final String broomballUrl = "https://broomball.mtu.edu/teams/view/";

  Future<BroomballData> run(String year) async {
    BroomballData broomballData = BroomballData();
    
    print("$broomballUrl$year");
    final Response response = await get("$broomballUrl$year");
    if (response.statusCode == 200) {
      // Success
      print("Loaded page");
      Document document = parse(response.body);

      List<Element> conferenceElements = document.querySelectorAll("#main_content_container > h1");
      List<Element> divisionElements = document.querySelectorAll("#main_content_container > blockquote");

      for (int i = 0; i < conferenceElements.length; i++) {
        Conference conference = Conference();
        String conferenceName = conferenceElements[i].text;
        print(conferenceName);

        List<Element> divisionHeaders = divisionElements[i].querySelectorAll("h1");
        List<Element> divisionTables = divisionElements[i].querySelectorAll("table > tbody");

        for (int j = 0; j < divisionHeaders.length; j++) {
          Division division = Division();

          String divisionName = divisionHeaders[j].text;

          List<Element> tableRows = divisionTables[j].querySelectorAll("tr");

          for (int k = 1; k < tableRows.length; k++) {
            String teamID;
            String teamName;

            List<Element> cells = tableRows[k].querySelectorAll("td");
            List<String> splitURL = cells[0].querySelector("a").attributes["href"].split("/");

            teamID = splitURL.last;
            teamName = cells[0].querySelector("a").text;

            division.teamIDs.add(teamID);
            broomballData.teams[teamID] = teamName;
          }
          conference.divisions[divisionName] = division;
        }
        broomballData.conferences[conferenceName] = conference;
      }

      broomballData.year = year;

      print("Finished!");
      return broomballData;
    } else {
      throw Exception("Error connecting to broomball site.");
    }
  }
}

class BroomballAPI {
  static final BroomballAPI _instance = BroomballAPI._internal();

  factory BroomballAPI() {
    return _instance;
  }

  BroomballAPI._internal();

  /// Fetches a player's data from broomball.mtu.edu/api/player/id/$id/key/0
  Future<Player> fetchPlayer(String id) async {
    final Response response = await get("https://www.broomball.mtu.edu/api/player/id/" + id + "/key/0");
    if (response.statusCode == 200) {
      return Player.fromJson(json.decode(response.body));
    } else {
      throw Exception("Unable to load player data");
    }
  }

  /// Fetches search data from broomball.mtu.edu/api/player/search/$query/key/0
  Future<Player> fetchSearch(String query) async {
    final Response searchResponse = await get("https://www.broomball.mtu.edu/api/player/search/" + query + "/key/0");
    //final Response response = await get("https://www.broomball.mtu.edu/api/player/id/" + json.decode(searchResponse.body).id + "/key/0");
    if (searchResponse.statusCode == 200) {
      String id = Search.fromJson(json.decode(searchResponse.body)).id;
      return fetchPlayer(id);
    } else {
      throw Exception("Unable to load search data");
    }
  }

  /// Fetches a team's data from broomball.mtu.edu/api/team/id/$id/key/0
  Future<Team> fetchTeam(String id) async {
    final Response response = await get("https://www.broomball.mtu.edu/api/team/id/" + id + "/key/0");

    if (response.statusCode == 200) {
      return Team.fromJson(json.decode(response.body));
    } else {
      throw Exception("Unable to load team data");
    }
  }
}

/// Class representing a player fetched from the API.
class Player {
  final String id;
  final String firstName;
  final String lastName;
  final String displayName;
  final String mtuId;
  final String displayAlias;
  final String email;

  final List<PlayerStatsMatch> stats;

  Player({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.displayName,
    @required this.mtuId,
    @required this.displayAlias,
    @required this.email,
    @required this.stats,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json["info"]["id"],
      firstName: json["info"]["first_name"],
      lastName: json["info"]["last_name"],
      displayName: json["info"]["display_name"],
      mtuId: json["info"]["mtu_id"],
      displayAlias: json["info"]["display_alias"],
      email: json["info"]["email"],
    );
  }
}

/// Class representing a match in a player's schedule.
class PlayerStatsMatch {
  final String gameId;
  final String playerId;
  final String teamId;
  final String present;
  final String goals;
  final String assists;
  final String penaltyMinutes;
  final String goalieMinutes;
  final String saves;
  final String goalsAllowed;
  final String medical;
  final String comment;

  PlayerStatsMatch({
    @required this.gameId,
    @required this.playerId,
    @required this.teamId,
    @required this.present,
    @required this.goals,
    @required this.assists,
    @required this.penaltyMinutes,
    @required this.goalieMinutes,
    @required this.saves,
    @required this.goalsAllowed,
    @required this.medical,
    @required this.comment,
  });

  factory PlayerStatsMatch.fromJson(Map<String, dynamic> json) {
    return PlayerStatsMatch(
      gameId: json["game_id"],
      playerId: json["player_id"],
      teamId: json["team_id"],
      present: json["present"],
      goals: json["goals"],
      assists: json["assists"],
      penaltyMinutes: json["penalty_minutes"],
      goalieMinutes: json["goalie_minutes"],
      saves: json["saves"],
      goalsAllowed: json["goals_allowed"],
      medical: json["medical"],
      comment: json["comment"],
    );
  }
}

/// Class representing a search fetched from the API.
class Search {
  final String id;

  Search({
    @required this.id,
  });

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      id: json["id"],
    );
  }
}

/// Class representing a team fetched from the API.
class Team {
  final String id;
  final String seasonId;
  final String registrationLeagueId;
  final String seasonLeagueId;
  final String conferenceNumber;
  final String name;
  final String rejectedRound1Name;
  final String rejectedRound2Name;
  final String captainPlayerId;
  final String nameApproved;
  final String freePlayers;
  final String ballsOrdered;
  final String registrationTime;
  final String validRoster;

  final List<TeamRosterPlayer> roster;
  final List<TeamScheduleMatch> schedule;

  Team({
    @required this.id,
    @required this.seasonId,
    @required this.registrationLeagueId,
    @required this.seasonLeagueId,
    @required this.conferenceNumber,
    @required this.name,
    @required this.rejectedRound1Name,
    @required this.rejectedRound2Name,
    @required this.captainPlayerId,
    @required this.nameApproved,
    @required this.freePlayers,
    @required this.ballsOrdered,
    @required this.registrationTime,
    @required this.validRoster,
    @required this.roster,
    @required this.schedule,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    List<TeamRosterPlayer> roster = <TeamRosterPlayer>[];
    List<TeamScheduleMatch> schedule = <TeamScheduleMatch>[];

    for (Map<String, dynamic> teamRosterPlayer in json["roster"].values.toList()) {
      roster.add(TeamRosterPlayer.fromJson(teamRosterPlayer));
    }

    for (Map<String, dynamic> teamScheduleMatch in json["schedule"]) {
      schedule.add(TeamScheduleMatch.fromJson(teamScheduleMatch));
    }

    return Team(
      id: json["info"]["id"],
      seasonId: json["info"]["season_id"],
      registrationLeagueId: json["info"]["registration_league_id"],
      seasonLeagueId: json["info"]["season_league_id"],
      conferenceNumber: json["info"]["conference_number"],
      name: json["info"]["name"],
      rejectedRound1Name: json["info"]["rejected_round_1_name"],
      rejectedRound2Name: json["info"]["rejected_round_2_name"],
      captainPlayerId: json["info"]["captain_player_id"],
      nameApproved: json["info"]["name_approved"],
      freePlayers: json["info"]["free_players"],
      ballsOrdered: json["info"]["balls_ordered"],
      registrationTime: json["info"]["registration_time"],
      validRoster: json["info"]["valid_roster"],
      roster: roster,
      schedule: schedule,
    );
  }
}

/// Class representing a player in a team's roster. Data for a player on a team
/// is different from that of a player's data fetched straight from the API.
class TeamRosterPlayer {
  final String teamId;
  final String playerId;
  final String id;
  final String firstName;
  final String lastName;
  final String displayName;
  final String mtuId;
  final String displayAlias;
  final String email;
  final String seasonId;
  final String classCrn;
  final String residency;
  final String isAdmin;
  final String active;
  final String meetingRep;

  TeamRosterPlayer({
    @required this.teamId,
    @required this.playerId,
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.displayName,
    @required this.mtuId,
    @required this.displayAlias,
    @required this.email,
    @required this.seasonId,
    @required this.classCrn,
    @required this.residency,
    @required this.isAdmin,
    @required this.active,
    @required this.meetingRep,
  });

  factory TeamRosterPlayer.fromJson(Map<String, dynamic> json) {
    return TeamRosterPlayer(
      teamId: json["team_id"],
      playerId: json["player_id"],
      id: json["id"],
      firstName: json["first_name"],
      lastName: json["last_name"],
      displayName: json["display_name"],
      mtuId: json["mtu_id"],
      displayAlias: json["display_alias"],
      email: json["email"],
      seasonId: json["season_id"],
      classCrn: json["class_crn"],
      residency: json["residency"],
      isAdmin: json["residency"],
      active: json["active"],
      meetingRep: json["meeting_rep"],
    );
  }
}

/// Class representing a match in a team's schedule.
class TeamScheduleMatch {
  final String gameId;
  final String played;
  final String otl;
  final String videoUrl;
  final String rinkName;
  final String canceled;
  final String homeTeamId;
  final String homeTeamName;
  final String homeGoals;
  final String awayTeamId;
  final String awayTeamName;
  final String awayGoals;
  final String rinkId;
  final String forfeited;
  final String startTime;

  TeamScheduleMatch({
    @required this.gameId,
    @required this.played,
    @required this.otl,
    @required this.videoUrl,
    @required this.rinkName,
    @required this.canceled,
    @required this.homeTeamId,
    @required this.homeTeamName,
    @required this.homeGoals,
    @required this.awayTeamId,
    @required this.awayTeamName,
    @required this.awayGoals,
    @required this.rinkId,
    @required this.forfeited,
    @required this.startTime,
  });

  factory TeamScheduleMatch.fromJson(Map<String, dynamic> json) {
    DateFormat dateFormat = new DateFormat("EEE. MMM d, yyyy");

    return TeamScheduleMatch(
      gameId: json["game_id"],
      played: json["played"],
      otl: json["otl"],
      videoUrl: json["video_url"],
      rinkName: json["rink_name"],
      canceled: json["canceled"],
      homeTeamId: json["home_team_id"],
      homeTeamName: json["home_team_name"],
      homeGoals: json["home_goals"],
      awayTeamId: json["away_team_id"],
      awayTeamName: json["away_team_name"],
      awayGoals: json["away_goals"],
      rinkId: json["rink_id"],
      forfeited: json["forfeited"],
      startTime: dateFormat.format(DateTime.parse(json["start_time"])),
    );
  }
}
