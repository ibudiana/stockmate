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
    // --- Arrange & Act ---
    final db = await dbService.database;

    // --- Assert ---
    expect(db, isNotNull);

    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='items'",
    );
    expect(result.length, 1);
    expect(result.first['name'], 'items');
  });

  test('Can insert and retrieve an item', () async {
    // --- Arrange ---
    final db = await dbService.database;
    final itemData = {
      'name': 'Test Item',
      'unit': 'pcs',
      'stock': 10,
      'min_stock': 2,
    };

    // --- Act ---
    final id = await db.insert('items', itemData);
    final items = await db.query('items');

    // --- Assert ---
    expect(id, greaterThan(0));
    expect(items.length, 1);
    expect(items.first['name'], 'Test Item');
    expect(items.first['stock'], 10);
  });

  test('Can update an item', () async {
    // --- Arrange ---
    final db = await dbService.database;
    final itemData = {
      'name': 'Test Item',
      'unit': 'pcs',
      'stock': 10,
      'min_stock': 2,
    };
    final id = await db.insert('items', itemData);

    // --- Act ---
    final count = await db.update(
      'items',
      {'stock': 20},
      where: 'id = ?',
      whereArgs: [id],
    );
    final items = await db.query('items', where: 'id = ?', whereArgs: [id]);

    // --- Assert ---
    expect(count, 1);
    expect(items.first['stock'], 20);
  });

  test('Can delete an item', () async {
    // --- Arrange ---
    final db = await dbService.database;
    final itemData = {
      'name': 'Test Item',
      'unit': 'pcs',
      'stock': 10,
      'min_stock': 2,
    };
    final id = await db.insert('items', itemData);

    // --- Act ---
    final count = await db.delete('items', where: 'id = ?', whereArgs: [id]);
    final items = await db.query('items', where: 'id = ?', whereArgs: [id]);

    // --- Assert ---
    expect(count, 1);
    expect(items.length, 0);
  });
}
