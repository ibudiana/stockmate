import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/data/local/database_service.dart';
import 'package:inventory/data/local/item_dao.dart';
import 'package:inventory/model/model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Inisialisasi FFI untuk SQLite di Dart VM
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseService dbService;
  late ItemDao itemDao;

  setUp(() {
    dbService = DatabaseService(inMemory: true);
    itemDao = ItemDao(dbService: dbService);
  });

  tearDown(() async {
    final db = await dbService.database;
    await db.close();
  });

  test('Can insert and retrieve an item via ItemDao', () async {
    // --- Arrange ---
    final item = Item(name: 'Test Item', unit: 'pcs', stock: 10);

    // --- Act ---
    final id = await itemDao.insertItem(item);
    final items = await itemDao.getItems();

    // --- Assert ---
    expect(id, greaterThan(0));
    expect(items.length, 1);
    expect(items.first.name, 'Test Item');
    expect(items.first.stock, 10);
  });

  test('Can update an item via ItemDao', () async {
    // --- Arrange ---
    final item = Item(name: 'Test Item', unit: 'pcs', stock: 10);
    final id = await itemDao.insertItem(item);
    final updatedItem = Item(id: id, name: 'Test Item', unit: 'pcs', stock: 20);

    // --- Act ---
    final count = await itemDao.updateItem(updatedItem);
    final items = await itemDao.getItems();

    // --- Assert ---
    expect(count, 1);
    expect(items.first.stock, 20);
  });

  test('Update non-existing item should return 0', () async {
    // --- Arrange ---
    final updatedItem = Item(
      id: 999,
      name: 'Non-existing',
      unit: 'pcs',
      stock: 20,
    );

    // --- Act ---
    final count = await itemDao.updateItem(updatedItem);

    // --- Assert ---
    expect(count, 0);
  });

  test('Can delete an item via ItemDao', () async {
    // --- Arrange ---
    final item = Item(name: 'Test Item', unit: 'pcs', stock: 10);
    final id = await itemDao.insertItem(item);

    // --- Act ---
    final count = await itemDao.deleteItem(id);
    final items = await itemDao.getItems();

    // --- Assert ---
    expect(count, 1);
    expect(items.length, 0);
  });

  test('Delete non-existing item should return 0', () async {
    // --- Arrange ---
    final nonExistingId = 999;

    // --- Act ---
    final count = await itemDao.deleteItem(nonExistingId);

    // --- Assert ---
    expect(count, 0);
  });

  test('Retrieve items from empty database should return empty list', () async {
    // --- Arrange ---
    // Tidak ada item yang ditambahkan

    // --- Act ---
    final items = await itemDao.getItems();

    // --- Assert ---
    expect(items, isEmpty);
  });
}
