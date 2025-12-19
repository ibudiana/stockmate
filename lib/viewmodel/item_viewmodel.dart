import 'package:flutter/material.dart';
import 'package:inventory/data/response/data_response.dart';
import 'package:inventory/data/response/status.dart';
import 'package:inventory/model/model.dart';
import 'package:inventory/repository/repository.dart';

class ItemViewModel extends ChangeNotifier {
  final ItemRepositoryImplementation _repo;

  ItemViewModel({required ItemRepositoryImplementation repository})
    : _repo = repository;

  DataResponse<List<Item>> items = DataResponse.loading();
  DataResponse<Item?> selectedItem = DataResponse.loading();

  /// Load all items
  Future<void> fetchItems() async {
    items = DataResponse.loading();
    notifyListeners();

    final response = await _repo.getAllItems();
    items = response;

    notifyListeners();
  }

  /// Insert item
  Future<void> addItem(Item item) async {
    final response = await _repo.insertItem(item);

    if (response.status == Status.success) {
      await fetchItems();
    } else {
      items = DataResponse.error(response.message ?? "Insert Failed");
      notifyListeners();
    }
  }

  /// Update item
  Future<void> updateItem(Item item) async {
    final response = await _repo.updateItem(item);

    if (response.status == Status.success) {
      await fetchItems();
    } else {
      items = DataResponse.error(response.message ?? "Update Failed");
      notifyListeners();
    }
  }

  /// Delete
  Future<void> deleteItem(int id) async {
    final response = await _repo.deleteItem(id);

    if (response.status == Status.success) {
      await fetchItems();
    } else {
      items = DataResponse.error(response.message ?? "Delete Failed");
      notifyListeners();
    }
  }

  // Search item by name
  Future<void> searchItems(String query) async {
    items = DataResponse.loading();
    notifyListeners();

    try {
      final allItemsResponse = await _repo.getAllItems();
      if (allItemsResponse.status == Status.success) {
        final filteredItems =
            allItemsResponse.data!
                .where(
                  (item) =>
                      item.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
        items = DataResponse.success(filteredItems);
      } else {
        items = DataResponse.error(allItemsResponse.message ?? "Search Failed");
      }
    } catch (e) {
      items = DataResponse.error("Search Failed: $e");
    }

    notifyListeners();
  }
}
