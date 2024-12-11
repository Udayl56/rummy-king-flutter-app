import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:rummy_king/database_services/db_operations.dart';

class RummyKingProvider with ChangeNotifier {
  final DbOperations _dbOperation = DbOperations();

// defalut point limit 200

  int _poolLimit = 200;

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

  List<String> get playerNameInGame => _playerInGame.keys.toList();

// set Player
  void setPlayer(int player) {
    _totalPlayer = player;
    print(_totalPlayer);

    notifyListeners();
  }

// set PoolLimit
  void setPool(int pool) {
    _poolLimit = pool;

    notifyListeners();
  }

  // create new table game
  Future<void> startNewGame() async {
    _playerInGame.clear();
    for (var i = 0; i < totalPlayer; i++) _playerInGame[_playerName[i]] = 0;
    await _dbOperation.insertNewGame(_poolLimit, _totalPlayer);
  }

// continue Game

  void continueGame(String gameId, int pool, int player) {
    _poolLimit = pool;
    _totalPlayer = player;
    _playerInGame.clear();
    for (var i = 0; i < totalPlayer; i++) _playerInGame[_playerName[i]] = 0;

    _dbOperation.setContinueGameName(gameId);
  }
}
