import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

// TODO: Create handler for when there is not favorites file

class AppData {
  FavoritesData favoritesData;

  static final AppData _instance = AppData._internal();

  factory AppData() {
    return _instance;
  }

  AppData._internal();

  /// Gets the local path where the JSON file gets stored
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;

    return File("$path/favorites.json");
  }

  Future<FavoritesData> loadFavoritesData() async {
    try {
      final File file = await _localFile;
      String contents = await file.readAsString();

      return FavoritesData.fromJson(json.decode(contents));
    } catch (e) {
      writeFavoritesData(FavoritesData(players: {}, teams: {}));
      return FavoritesData(players: {}, teams: {});
    }
  }

  Future<File> writeFavoritesData(FavoritesData favoritesData) async {
    final File file = await _localFile;
    return file.writeAsString(json.encode(favoritesData.toJson()));
  }
}

class FavoritesData {
  Map<String, String> teams;
  Map<String, String> players;

  FavoritesData({@required this.teams, @required this.players});

  factory FavoritesData.fromJson(Map<String, dynamic> json) {
    return FavoritesData(
      teams: json["teams"],
      players: json["players"],
    );
  }

  Map<String, Map<String, String>> toJson() {
    Map<String, Map<String, String>> json = Map<String, Map<String, String>>();
    json["teams"] = teams;
    json["players"] = players;

    return json;
  }
}
