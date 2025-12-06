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
    final item = Item(name: 'Test Item', unit: 'pcs', stock: 10);

    int id = await itemDao.insertItem(item);
    expect(id, greaterThan(0));

    final items = await itemDao.getItems();
    expect(items.length, 1);
    expect(items.first.name, 'Test Item');
    expect(items.first.stock, 10);
  });

  test('Can update an item via ItemDao', () async {
    final item = Item(name: 'Test Item', unit: 'pcs', stock: 10);
    int id = await itemDao.insertItem(item);

    final updatedItem = Item(id: id, name: 'Test Item', unit: 'pcs', stock: 20);
    int count = await itemDao.updateItem(updatedItem);
    expect(count, 1);

    final items = await itemDao.getItems();
    expect(items.first.stock, 20);
  });

  test('Can delete an item via ItemDao', () async {
    final item = Item(name: 'Test Item', unit: 'pcs', stock: 10);
    int id = await itemDao.insertItem(item);

    int count = await itemDao.deleteItem(id);
    expect(count, 1);

    final items = await itemDao.getItems();
    expect(items.length, 0);
  });
}
