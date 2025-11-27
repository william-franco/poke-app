import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/src/common/dependency_injectors/dependency_injector.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/presentation/view_models/pokemons_view_model.dart';
import 'package:poke_app/src/features/pokemons/presentation/views/pokemon_detail_view.dart';
import 'package:poke_app/src/features/pokemons/presentation/views/pokemons_view.dart';

class PokemonsRoutes {
  static String get pokemons => '/pokemons';
  static String get pokemonDetail => '/pokemons-detail';

  List<GoRoute> get routes => _routes;

  final List<GoRoute> _routes = [
    GoRoute(
      path: pokemons,
      builder: (context, state) {
        return PokemonsView(pokemonsViewModel: locator<PokemonsViewModel>());
      },
    ),
    GoRoute(
      path: pokemonDetail,
      pageBuilder: (context, state) {
        final pokemon = state.extra as PokemonEntity;

        return CustomTransitionPage(
          opaque: false,
          barrierDismissible: false,
          barrierColor: Colors.black54,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(color: Colors.black54),
              ),

              PokemonDetailView(
                pokemon: pokemon,
                viewModel: locator<PokemonsViewModel>(),
              ),
            ],
          ),
          transitionsBuilder: (context, animation, _, child) {
            final curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            );

            return FadeTransition(
              opacity: curved,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(curved),
                child: child,
              ),
            );
          },
        );
      },
    ),
  ];
}
