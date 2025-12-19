import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'providers.dart';
import 'app.dart';
import 'shared/shared.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env", mergeWith: {'TEST_VAR': '5'});

  Const.databaseName = dotenv.get('DB_NAME', fallback: 'inventory.db');

  runApp(
    MultiProvider(
      providers: AppProviders.providers(),
      child: const StockMateApp(),
    ),
  );
}
