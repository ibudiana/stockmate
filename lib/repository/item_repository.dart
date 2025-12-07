part of 'repository.dart';

class ItemRepository implements BaseRepository<Item> {
  final ItemDao _itemDao;

  ItemRepository({required ItemDao itemDao}) : _itemDao = itemDao;

  @override
  Future<DataResponse<List<Item>>> getAllItems() async {
    try {
      final items = await _itemDao.getItems();
      return DataResponse.success(items);
    } catch (e) {
      return DataResponse.error("Failed to get items: $e");
    }
  }

  @override
  Future<DataResponse<Item?>> getItemById(int id) async {
    final items = await _itemDao.getItems();
    try {
      return DataResponse.success(items.firstWhere((item) => item.id == id));
    } catch (e) {
      return DataResponse.error("Failed to get item by id: $e");
    }
  }

  @override
  Future<DataResponse<int>> insertItem(Item item) async {
    try {
      final id = await _itemDao.insertItem(item);
      return DataResponse.success(id);
    } catch (e) {
      return DataResponse.error("Failed to insert item: $e");
    }
  }

  @override
  Future<DataResponse<int>> updateItem(Item item) async {
    try {
      final updatedItem = await _itemDao.updateItem(item);
      return DataResponse.success(updatedItem);
    } catch (e) {
      return DataResponse.error("Failed to update item: $e");
    }
  }

  @override
  Future<DataResponse<int>> deleteItem(int id) async {
    try {
      final deletedItem = await _itemDao.deleteItem(id);
      return DataResponse.success(deletedItem);
    } catch (e) {
      return DataResponse.error("Failed to delete item: $e");
    }
  }

  // Future<DataResponse<List<Item>>> searchItems(String query) async {
  //   try {
  //     if (query.isEmpty) {
  //       return await getAllItems();
  //     }

  //     final result = await _itemDao.findItemByName(query);

  //     if (result == null) {
  //       return DataResponse.success([]);
  //     }

  //     final List<Item> items = [result];
  //     return DataResponse.success(items);
  //   } catch (e) {
  //     return DataResponse.error("Failed to search data: $e");
  //   }
  // }
}
