import 'dart:ffi';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rummy_king/database_services/db_config.dart';

import 'package:rummy_king/database_services/db_operations.dart';

class RummyKingProvider with ChangeNotifier {
  final DbOperations _dbOperation = DbOperations();

// defalut point limit 200

  int _poolLimit = 200;
  late int _entryPoint = _poolLimit - 25;

  int get poolLimit => _poolLimit;

// defalut selected player

  int _totalPlayer = 4;

  int get totalPlayer => _totalPlayer;

// Player In Game

  final List<String> _playerName = [
    "Sakuni",
    "Yudhis",
    "Duryod",
    "Karna",
    "Bhim",
    "Arjuna"
  ];

  Map<String, int> _playerInGame = {};

  int _playerTableName = 4;

  List<String> get playerNameInGame => _playerInGame.keys.toList();

// set Player
  void setPlayer(int player) {
    _totalPlayer = player;
    _playerTableName = player;
    // print(_totalPlayer);

    notifyListeners();
  }

// set PoolLimit
  set setPool(int pool) {
    // print(_totalPlayer);
    _poolLimit = pool;

    notifyListeners();
  }

  // create new table game

  List<dynamic> _scorData = [];

  List<dynamic> get data => _scorData;

  Future<void> fetchData() async {
    _scorData = await _dbOperation.readCurrGameScore();

    notifyListeners(); // Notify widgets to rebuild
  }

  final Map<String, int> _totalScore = {};
  List<int> get totalScore => _totalScore.values.toList();

  Future<void> insertData(Map<String, int> row) async {
    for (final entry in row.entries) {
      _totalScore[entry.key] = (_totalScore[entry.key] ?? 0) + entry.value;
    }
    await _dbOperation.insertRoundscore(row);

    await fetchData(); // Refresh after insertion
  }

  Future<void> startNewGame() async {
    _dbOperation.setRound = 0;
    _totalScore.clear();
    _scorData.clear();
    _playerInGame.clear();
    for (var i = 0; i < totalPlayer; i++) _playerInGame[_playerName[i]] = 0;
    await _dbOperation.insertNewGame(_poolLimit, _totalPlayer);
  }

  List<String> get playerTableName => _playerName.sublist(0, _playerTableName);

// continue Game
  Future<void> continueGame(String gameId, int pool, int player) async {
    _dbOperation.gameId = gameId;
    _poolLimit = pool;
    _totalPlayer = player;
    _playerTableName = player;
    _playerInGame.clear();
    _scorData.clear();
    _totalScore.clear();
    final record = await _dbOperation.continueGameSetScore();
    // print('continue game record :$record');
    if (record.isEmpty) {
      for (int i = 0; i < player; i++) {
        _playerInGame[_playerName[i]] = 0;
      }
    } else {
      record.forEach((map) {
        map.forEach((key, value) {
          if (value is int && key != 'round') {
            _playerInGame[key] = (_playerInGame[key] ?? 0) + value;
            _totalScore[key] = (_totalScore[key] ?? 0) + value;
          }
        });
      });
    }

    await fetchData();
    //print(gameId);

    //print('continue player:$_playerTableName');

    _playerInGame.removeWhere((key, value) => value > _poolLimit);

    notifyListeners();
  }

  // game logic

  int get playerInGameSize => _playerInGame.length;

  List<String> getOutPlayer() {
    List<String> outPlayer = [];
    for (var key in _playerInGame.keys) {
      if (_playerInGame[key]! > _poolLimit) {
        outPlayer.add(key);
      }
    }
    _playerInGame.removeWhere((key, value) => value > _poolLimit);
    return outPlayer;
  }

//check entry avaible for out player

  int getEntryPoint() {
    if (_playerInGame.length >= 2) {
      int isEntryPoint = 0;
      for (var key in _playerInGame.keys) {
        if (_playerInGame[key]! < _entryPoint) {
          isEntryPoint = max(_playerInGame[key]!, isEntryPoint);
        }
        if (_playerInGame[key]! > _entryPoint &&
            _playerInGame[key]! < _poolLimit) {
          return 0;
        }
      }
      return isEntryPoint;
    }
    return 0;
  }

// player rejoin game

  void removePlayer(
      List<bool> checkRejoinGame, List<String> outPlayer, int entryPoint) {
    for (var i = 0; i < outPlayer.length; i++) {
      if (checkRejoinGame[i]) {
        _playerInGame[outPlayer[i]] = entryPoint;
        _totalScore[outPlayer[i]] = entryPoint;
      } else {
        _playerInGame.remove(outPlayer[i]);
      }
    }
    notifyListeners();
  }

  // Update total score
  void updateScore(Map<String, dynamic> row) {
    row.entries.forEach((entry) {
      // Get the player and score from the entry
      String player = entry.key;
      int score = entry.value;

      // Update the player's score in _playerInGame
      // Use 0 as the default value if the player doesn't exist in the map
      _playerInGame[player] = (_playerInGame[player] ?? 0) + score;
    });
  }

  // Determine game winner
  String? winner() {
    return _playerInGame.length == 1 ? _playerInGame.keys.first : null;
  }
}
