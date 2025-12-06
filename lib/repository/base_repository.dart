part of 'repository.dart';

abstract class BaseRepository<T> {
  Future<DataResponse<List<T>>> getAllItems();
  Future<DataResponse<T?>> getItemById(int id);
  Future<DataResponse<int>> insertItem(T item);
  Future<DataResponse<int>> updateItem(T item);
  Future<DataResponse<int>> deleteItem(int id);
}
