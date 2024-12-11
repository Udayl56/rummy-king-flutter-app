import 'package:flutter/material.dart';
import 'package:rummy_king/database_services/db_config.dart';

class DbOperations with ChangeNotifier {
  final DBHelper _dbHelper = DBHelper();

  static final DbOperations _dbInstant = DbOperations._privateConstructor();
  DbOperations._privateConstructor();

  factory DbOperations() {
    return _dbInstant;
  }

  final List<String> _playerName = [
    "Sakuni",
    "Yudhis",
    "Duryod",
    "Karna",
    "Bhim",
    "Arjuna"
  ];

  //int _totalPlayer = 4;
  String? _gameId;

  Future<void> getStartGameId() async {
    try {
      final db = await _dbHelper.databaseService();
      final result = await db.rawQuery(
          'SELECT ${_dbHelper.col_1} FROM ${_dbHelper.tableName} ORDER BY ${_dbHelper.col_1} DESC LIMIT 1');
      if (result.isNotEmpty) {
        _gameId = result.first[_dbHelper.col_1].toString();
      }
      print('\ngame id:');
      print(_gameId);
    } catch (e) {
      print(e);
      print('Error getting table name id');
    }
  }

  Stream<List<dynamic>> readCurrGameScore() async* {
    try {
      print('Fetching current game score from gameid $_gameId');
      final db = await _dbHelper.databaseService();
      final sqlQuery = 'SELECT * FROM Game_$_gameId';
      final record = await db.rawQuery(sqlQuery);
      yield record.map((row) => row.values.toList()).toList();
    } catch (e) {
      print('Error reading from database: $e');
      yield [];
    }
  }

  // insert row in master table

  Future<void> insertNewGame(int pointLimit, int totalPlayer) async {
    try {
      final db = await _dbHelper.databaseService();
      await db.insert(_dbHelper.tableName, {
        _dbHelper.col_3: pointLimit,
        _dbHelper.col_4: totalPlayer,
      });
      await getStartGameId();

      await creatNewGametable(totalPlayer);
    } catch (e) {
      print("Error in insertNewGame: $e");
    }
  }

// create new table
  Future<void> creatNewGametable(int totalPlayer) async {
    final String query = _TableQuery(totalPlayer);
    print("Creating table with query: $query");
    try {
      final db = await _dbHelper.databaseService();
      await db.execute(query);
    } catch (e) {
      print("Error creating new table: $e");
    }
  }

  String _TableQuery(int totalPlayer) {
    String sql =
        '''CREATE TABLE Game_$_gameId (round INTEGER PRIMARY KEY AUTOINCREMENT,''';

    for (var i = 0; i < totalPlayer; i++) {
      if (i == totalPlayer - 1) {
        sql += '${_playerName[i]} INTEGER)';
      } else
        sql += '${_playerName[i]} INTEGER,';
    }

    return sql;
  }

  // get table name

// insert current game score
  Future<void> insertRoundscore(Map<String, dynamic> row) async {
    try {
      final db = await _dbHelper.databaseService();
      // final gameName = await readCurrTableName(); // Await the asynchronous call

      print('Inserting into table: Game_$_gameId');
      await db.insert('Game_$_gameId', row);
      print('Insert successful');
    } catch (e) {
      print('Error inserting into database: $e');
    }
  }

  // set continue gamename

  void setContinueGameName(String gameId) {
    _gameId = gameId;
  }

//  get all game history record
  Future<List<Map<String, dynamic>>> readAllGame() async {
    try {
      final db = await _dbHelper.databaseService();
      print('featch all game history record');
      final String sqlQuery =
          'SELECT ${_dbHelper.col_1}, ${_dbHelper.col_2},${_dbHelper.col_3},${_dbHelper.col_4} FROM ${_dbHelper.tableName}  ORDER BY ${_dbHelper.col_1} DESC';

      final record = await db.rawQuery(sqlQuery);

      return record;
    } catch (e) {
      print('Error reading from database: $e');
      return []; // Return an empty list if reading fails
    }
  }

  Future<void> deleteGame(int gameId) async {
    try {
      final db = await _dbHelper.databaseService();
      await db.delete(_dbHelper.tableName,
          where: '${_dbHelper.col_1} = ?', whereArgs: [gameId]);
      await db.execute('DROP TABLE IF EXISTS $gameId');
    } catch (e) {
      print('exception occur when deleting row $e');
    }
  }
}
