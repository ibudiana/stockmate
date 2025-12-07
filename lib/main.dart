import 'package:flutter/material.dart';
import 'package:inventory/shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:inventory/repository/repository.dart';
import 'package:inventory/viewmodel/item_viewmodel.dart';
import 'package:inventory/data/local/database_service.dart';
import 'package:inventory/data/local/item_dao.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:inventory/view/pages/pages.dart';

void main() async {
  await dotenv.load(fileName: "assets/.env", mergeWith: {'TEST_VAR': '5'});
  // print("DB_NAME: ${dotenv.get('DB_NAME')}");

  // set nilai Const dari dotenv
  Const.databaseName = dotenv.get('DB_NAME', fallback: 'inventory.db');

  WidgetsFlutterBinding.ensureInitialized();

  // Setup database & repository
  final dbService = DatabaseService();
  // final itemDao = ItemDao(dbService: dbService);
  // final itemRepo = ItemRepository(itemDao: itemDao);

  runApp(
    MultiProvider(
      providers: [
        Provider<ItemRepository>(
          create: (context) {
            final itemDao = ItemDao(dbService: dbService);
            return ItemRepository(itemDao: itemDao);
          },
        ),
        ChangeNotifierProvider(
          create:
              (context) =>
                  ItemViewModel(repository: context.read<ItemRepository>())
                    ..fetchItems(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ItemPage(),
      ),
    ),
  );
}
