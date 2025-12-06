import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:inventory/shared/shared.dart';

class DatabaseService {
  Database? _database;
  final bool inMemory;

  DatabaseService({this.inMemory = false});

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path;
    if (inMemory) {
      path = inMemoryDatabasePath;
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, Const.databaseName);
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        unit TEXT NOT NULL,
        stock INTEGER NOT NULL,
        min_stock INTEGER
      );
    ''');
  }
}
