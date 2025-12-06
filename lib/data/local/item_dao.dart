import 'package:inventory/data/local/database_service.dart';
import 'package:inventory/model/model.dart';

class ItemDao {
  final DatabaseService _dbService;

  ItemDao({required DatabaseService dbService}) : _dbService = dbService;

  Future<List<Item>> getItems() async {
    final db = await _dbService.database;
    final data = await db.query('items');
    return data.map((e) => Item.fromMap(e)).toList();
  }

  Future<int> insertItem(Item item) async {
    final db = await _dbService.database;
    return db.insert('items', item.toMap());
  }

  Future<int> updateItem(Item item) async {
    final db = await _dbService.database;
    return db.update(
      'items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int id) async {
    final db = await _dbService.database;
    return db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  // // Find item by name
  // Future<Item?> findItemByName(String name) async {
  //   final db = await _dbService.database;
  //   final data = await db.query('items', where: 'name = ?', whereArgs: [name]);
  //   if (data.isNotEmpty) {
  //     return Item.fromMap(data.first);
  //   }
  //   return null;
  // }
}
