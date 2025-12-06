import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/data/local/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // INIT FFI agar sqflite bisa jalan di Dart VM
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseService dbService;

  setUp(() {
    dbService = DatabaseService(inMemory: true);
  });

  test('Database connection should be successful', () async {
    final db = await dbService.database;

    // database is not null
    expect(db, isNotNull);

    // check if table 'items' exists
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='items'",
    );
    expect(result.length, 1);
    expect(result.first['name'], 'items');
  });

  test('Can insert and retrieve an item', () async {
    final db = await dbService.database;

    // insert dummy item
    int id = await db.insert('items', {
      'name': 'Test Item',
      'unit': 'pcs',
      'stock': 10,
      'min_stock': 2,
    });

    expect(id, greaterThan(0));

    // retrieve item
    final items = await db.query('items');
    expect(items.length, 1);
    expect(items.first['name'], 'Test Item');
    expect(items.first['stock'], 10);
  });

  test('Can update an item', () async {
    final db = await dbService.database;

    // insert dummy item
    int id = await db.insert('items', {
      'name': 'Test Item',
      'unit': 'pcs',
      'stock': 10,
      'min_stock': 2,
    });

    // update item
    int count = await db.update(
      'items',
      {'stock': 20},
      where: 'id = ?',
      whereArgs: [id],
    );

    expect(count, 1);

    // retrieve item
    final items = await db.query('items', where: 'id = ?', whereArgs: [id]);
    expect(items.first['stock'], 20);
  });

  test('Can delete an item', () async {
    final db = await dbService.database;

    // insert dummy item
    int id = await db.insert('items', {
      'name': 'Test Item',
      'unit': 'pcs',
      'stock': 10,
      'min_stock': 2,
    });

    // delete item
    int count = await db.delete('items', where: 'id = ?', whereArgs: [id]);

    expect(count, 1);

    // verify deletion
    final items = await db.query('items', where: 'id = ?', whereArgs: [id]);
    expect(items.length, 0);
  });
}
