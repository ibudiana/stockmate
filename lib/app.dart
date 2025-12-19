import 'package:flutter/material.dart';
import 'routers.dart';

class StockMateApp extends StatelessWidget {
  const StockMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      title: 'StockMate',
    );
  }
}
