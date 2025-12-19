import 'package:go_router/go_router.dart';
import 'package:inventory/view/pages/pages.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [GoRoute(path: '/', builder: (context, state) => const ItemPage())],
  );
}
