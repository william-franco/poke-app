import 'package:go_router/go_router.dart';
import 'package:poke_app/src/features/pokemons/presentation/routes/pokemons_routes.dart';

class Routes {
  static String get home => PokemonsRoutes.pokemons;

  GoRouter get routes => _routes;

  final GoRouter _routes = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: home,
    routes: [...PokemonsRoutes().routes],
  );
}
