import 'dart:math'; // Import for mathematical operations if needed
import 'package:flutter/foundation.dart';

class RummyKing with ChangeNotifier {
  // Player names
  final List<String> _playerName = [
    "Sakuni",
    "Yudhis",
    "Duryod",
    "Karnav",
    "Bhimaa",
    "Arjuna"
  ];

  int _totalPlayer = 4;
  int _pointLimit = 0;

  int _entryPoint = 175;

  int get totalPlayerInGame => _totalPlayer;
  int get pointLimit => _pointLimit;

  // Each player's score
  List<List<String>> _eachScoreEntry = [];
  Map<String, int> _playerInGame = {};

  int _currenRemainingtPlayer = 0;

  // get each player Entry Score

  List<List<String>> get eachScoreEntry => _eachScoreEntry;

  List<String> get playerNameInGame => _playerInGame.keys.toList();

  Map<String, int> get playerNameWithScore => _playerInGame;

  void setPlayer(int player) {
    _totalPlayer = player;

    notifyListeners();
  }

  void setCurrDealScore(List<String> score) {
    _eachScoreEntry.add(score);
    List<String> currPlayerNameList = _playerInGame.keys.toList();

    for (var i = 0; i < score.length; i++) {
      // Convert score[i] to an int before adding
      int currentScore = int.tryParse(score[i]) ?? 0;
      _playerInGame[currPlayerNameList[i]] =
          _playerInGame[currPlayerNameList[i]]! + currentScore;
    }

    notifyListeners();
  }

  // Setter
  void startGame(int point) {
    _pointLimit = point;

    _playerInGame.clear();

    for (var i = 0; i < _totalPlayer; i++) {
      _playerInGame[_playerName[i]] = 0;
    }
    notifyListeners();
  }

  // Get eliminated player list

  List<String> getOutPlayer() {
    _currenRemainingtPlayer = 0;
    List<String> outPlayer = [];
    for (var key in _playerInGame.keys) {
      if (_playerInGame[key]! > _pointLimit) {
        outPlayer.add(key);
      } else {
        _currenRemainingtPlayer++;
      }
    }

    return outPlayer;
  }

//check entry avaible for out player

  int getEntryPoint() {
    if (_currenRemainingtPlayer > 2) {
      int isEntryPoint = 0;
      for (var key in _playerInGame.keys) {
        if (_playerInGame[key]! < _entryPoint) {
          isEntryPoint = max(_playerInGame[key]!, isEntryPoint);
        }
        if (_playerInGame[key]! > _entryPoint &&
            _playerInGame[key]! < _pointLimit) {
          return 0;
        }
      }
      return isEntryPoint;
    } else {
      for (var key in getOutPlayer()) {
        // deacrease Total Player count in game
        _totalPlayer--;
        _playerInGame.remove(key);
      }
      // all player are eliminated from game thats why entry not available
      return 0;
    }
  }

// player rejoin game

  void removePlayer(
      List<bool> checkRejoinGame, List<String> outPlayer, int entryPoint) {
    for (var i = 0; i < outPlayer.length; i++) {
      if (checkRejoinGame[i]) {
        _totalPlayer++;
        _playerInGame[outPlayer[i]] = entryPoint;
      } else {
        _totalPlayer--;
        _playerInGame.remove(outPlayer[i]);
      }
    }
    notifyListeners();
  }

  // Update total score
  void updateScore(String player, int score) {
    _playerInGame[player] = _playerInGame[player]! + score;
  }

  // Determine game winner
  String? winner() {
    return _playerInGame.length == 1 ? _playerInGame.keys.first : null;
  }
}
