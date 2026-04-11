import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/src/common/widgets/empty_view_widget.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/presentation/routes/pokemons_routes.dart';
import 'package:poke_app/src/features/pokemons/presentation/widgets/pokemon_card_widget.dart';

class PokemonsGridViewWidget extends StatelessWidget {
  final List<PokemonEntity> pokemonList;

  const PokemonsGridViewWidget({super.key, required this.pokemonList});

  @override
  Widget build(BuildContext context) {
    if (pokemonList.isEmpty) return const EmptyViewWidget();

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
        final pokemon = pokemonList[index];
        return PokemonCardWidget(
          pokemon: pokemon,
          onTap: () {
            context.push(PokemonsRoutes.pokemonDetail, extra: pokemon);
          },
        );
      },
    );
  }
}
