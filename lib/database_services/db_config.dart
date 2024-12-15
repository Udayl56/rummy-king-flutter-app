import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  // singleton contractor

  static final DBHelper _dbInstant = DBHelper._privateConstructor();
  DBHelper._privateConstructor();

  factory DBHelper() {
    return _dbInstant;
  }

  // database configuration
  static final _databaseName = 'RummyKingGame.db';
  static final _databaseVersion = 1;
  static final _tableName = 'master';
  get tableName => _tableName;

  // column name in master database
  static final _col_1 = 'id';
  static final _col_2 = 'created_at';
  static final _col_3 = 'point_limit';
  static final _col_4 = 'player';
// get
  String get col_1 => _col_1;
  String get col_2 => _col_2;
  String get col_3 => _col_3;
  String get col_4 => _col_4;

  static Database? _database;

  // database Service
  Future<Database> databaseService() async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDataBase();
    return _database!;
  }

  //  Database initialization
  Future<Database?> _initDataBase() async {
    try {
      String databasePath = join(await getDatabasesPath(), _databaseName);
      return await openDatabase(
        databasePath,
        version: _databaseVersion,
        onCreate: (db, version) {
          try {
            db.execute('''
            CREATE TABLE $_tableName (
              $_col_1 INTEGER PRIMARY KEY AUTOINCREMENT,
              $_col_2 DATETIME DEFAULT CURRENT_TIMESTAMP,
              $_col_3 INTEGER NOT NULL,
              $_col_4 INTEGER NOT NULL

              )''');
          } catch (e) {
            // print('Error creating table: $e');
          }
        },
      );
    } catch (e) {
      // print('Error initializing database: $e');
      return null; // Return null if initialization fails
    }
  }
}
