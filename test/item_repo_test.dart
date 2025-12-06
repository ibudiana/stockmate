import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/data/local/database_service.dart';
import 'package:inventory/data/local/item_dao.dart';
import 'package:inventory/data/response/status.dart';
import 'package:inventory/model/model.dart';
import 'package:inventory/repository/item_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseService dbService;
  late ItemDao itemDao;
  late ItemRepository repo;

  setUp(() {
    dbService = DatabaseService(inMemory: true);
    itemDao = ItemDao(dbService: dbService);
    repo = ItemRepository(itemDao: itemDao);
  });

  tearDown(() async {
    final db = await dbService.database;
    await db.close();
  });

  test('Repository can insert and retrieve items', () async {
    final item = Item(name: 'Test', unit: 'pcs', stock: 10);

    final insertResponse = await repo.insertItem(item);
    expect(insertResponse.status, Status.success);
    expect(insertResponse.data, isNonZero);

    final allItemsResponse = await repo.getAllItems();
    expect(allItemsResponse.status, Status.success);
    expect(allItemsResponse.data!.length, 1);
    expect(allItemsResponse.data!.first.name, 'Test');
  });

  test('Repository can update item', () async {
    final item = Item(name: 'Test', unit: 'pcs', stock: 10);

    final inserted = await repo.insertItem(item);
    final id = inserted.data!;

    final updatedItem = Item(id: id, name: 'Test', unit: 'pcs', stock: 20);
    final updateResponse = await repo.updateItem(updatedItem);

    expect(updateResponse.status, Status.success);
    expect(updateResponse.data, 1);

    final all = await repo.getAllItems();
    expect(all.data!.first.stock, 20);
  });

  test('Repository can delete item', () async {
    final item = Item(name: 'Test', unit: 'pcs', stock: 10);
    final inserted = await repo.insertItem(item);
    final id = inserted.data!;

    final deleteResponse = await repo.deleteItem(id);
    expect(deleteResponse.status, Status.success);
    expect(deleteResponse.data, 1);

    final all = await repo.getAllItems();
    expect(all.data!.length, 0);
  });

  test('Repository handles getItemById correctly', () async {
    final item = Item(name: 'Test', unit: 'pcs', stock: 10);
    final inserted = await repo.insertItem(item);
    final id = inserted.data!;

    final result = await repo.getItemById(id);

    expect(result.status, Status.success);
    expect(result.data!.id, id);
    expect(result.data!.name, 'Test');
  });
}
