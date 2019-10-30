import 'dart:convert';

import 'package:http/http.dart';

class BroomballData {
  final String scraperDataURL =
      "https://classdb.it.mtu.edu/cs3141/BroomballApp/output.json";

  Map jsonData;

  static final BroomballData _instance = BroomballData._internal();

  factory BroomballData() {
    return _instance;
  }

  BroomballData._internal();

  Future<void> fetchJsonData() async {
    final Response response = await get(scraperDataURL);

    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
    } else {
      throw Exception("Error loading data");
    }
  }

  Future<Player> fetchPlayer(String id) async {
    final Response response = await get(
        "https://www.broomball.mtu.edu/api/player/id/" + id + "/key/0");

    if (response.statusCode == 200) {
      return Player.fromJson(json.decode(response.body));
    } else {
      throw Exception("Unable to load player data");
    }
  }
}

class Player {
  final String id;
  final String firstName;
  final String lastName;
  final String displayName;
  final String mtuId;
  final String displayAlias;
  final String email;

  Player(
      {this.id,
      this.firstName,
      this.lastName,
      this.displayName,
      this.mtuId,
      this.displayAlias,
      this.email});

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

class PlayerMatch {}
