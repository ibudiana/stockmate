import 'package:provider/provider.dart';
import 'package:nested/nested.dart';
import 'package:inventory/data/local/database_service.dart';
import 'package:inventory/data/local/item_dao.dart';
import 'package:inventory/repository/repository.dart';
import 'package:inventory/viewmodel/item_viewmodel.dart';

class AppProviders {
  static List<SingleChildWidget> providers() {
    final dbService = DatabaseService();

    return [
      Provider<ItemRepositoryImplementation>(
        create: (_) {
          final itemDao = ItemDao(dbService: dbService);
          return ItemRepositoryImplementation(itemDao: itemDao);
        },
      ),
      ChangeNotifierProvider<ItemViewModel>(
        create:
            (context) => ItemViewModel(
              repository: context.read<ItemRepositoryImplementation>(),
            )..fetchItems(),
      ),
    ];
  }
}
