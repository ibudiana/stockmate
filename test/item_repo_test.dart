import 'package:flutter_test/flutter_test.dart';
import 'package:inventory/data/local/database_service.dart';
import 'package:inventory/data/local/item_dao.dart';
import 'package:inventory/data/response/status.dart';
import 'package:inventory/model/model.dart';
import 'package:inventory/repository/repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize sqflite for FFI
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late DatabaseService dbService;
  late ItemDao itemDao;
  late ItemRepository repo;

  setUp(() {
    dbService = DatabaseService(inMemory: true);
    itemDao = ItemDao(dbService: dbService);
    repo = ItemRepositoryImplementation(itemDao: itemDao);
  });

  tearDown(() async {
    final db = await dbService.database;
    await db.close();
  });

  test('Repository can insert and retrieve items', () async {
    // --- Arrange ---
    final item = Item(name: 'Test', unit: 'pcs', stock: 10);

    // --- Act ---
    final insertResponse = await repo.insertItem(item);
    final allItemsResponse = await repo.getAllItems();

    // --- Assert ---
    expect(insertResponse.status, Status.success);
    expect(insertResponse.data, isNonZero);
    expect(allItemsResponse.status, Status.success);
    expect(allItemsResponse.data!.length, 1);
    expect(allItemsResponse.data!.first.name, 'Test');
  });

  test('Repository can update item', () async {
    // --- Arrange ---
    final item = Item(name: 'Test', unit: 'pcs', stock: 10);
    final inserted = await repo.insertItem(item);
    final id = inserted.data!;
    final updatedItem = Item(id: id, name: 'Test', unit: 'pcs', stock: 20);

    // --- Act ---
    final updateResponse = await repo.updateItem(updatedItem);
    final allItems = await repo.getAllItems();

    // --- Assert ---
    expect(updateResponse.status, Status.success);
    expect(updateResponse.data, 1);
    expect(allItems.data!.first.stock, 20);
  });

  test('Repository can delete item', () async {
    // --- Arrange ---
    final item = Item(name: 'Test', unit: 'pcs', stock: 10);
    final inserted = await repo.insertItem(item);
    final id = inserted.data!;

    // --- Act ---
    final deleteResponse = await repo.deleteItem(id);
    final allItems = await repo.getAllItems();

    // --- Assert ---
    expect(deleteResponse.status, Status.success);
    expect(deleteResponse.data, 1);
    expect(allItems.data!.length, 0);
  });

  test('Repository handles getItemById correctly', () async {
    // --- Arrange ---
    final item = Item(name: 'Test', unit: 'pcs', stock: 10);
    final inserted = await repo.insertItem(item);
    final id = inserted.data!;

    // --- Act ---
    final result = await repo.getItemById(id);

    // --- Assert ---
    expect(result.status, Status.success);
    expect(result.data!.id, id);
    expect(result.data!.name, 'Test');
  });
}
