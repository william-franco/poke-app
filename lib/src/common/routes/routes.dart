import 'package:go_router/go_router.dart';

class Routes {
  static String get home => '';

  GoRouter get routes => _routes;

  final GoRouter _routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: home,
    routes: [],
  );
}
