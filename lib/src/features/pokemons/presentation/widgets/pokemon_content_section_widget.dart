import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';
import 'package:poke_app/src/common/states/state.dart';
import 'package:poke_app/src/common/widgets/error_view_widget.dart';
import 'package:poke_app/src/features/pokemons/presentation/view_models/pokemons_view_model.dart';
import 'package:poke_app/src/features/pokemons/presentation/widgets/pokemons_grid_view_widget.dart';

class PokemonContentSectionWidget extends StatelessWidget {
  final PokemonsViewModel pokemonsViewModel;

  const PokemonContentSectionWidget({
    super.key,
    required this.pokemonsViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await pokemonsViewModel.loadPokemon();
      },
      child: ListenableBuilder(
        listenable: pokemonsViewModel,
        builder: (context, _) {
          final state = pokemonsViewModel.pokemonState;

          return switch (state) {
            InitialState() => const Center(
              child: Text('Pressione para carregar'),
            ),
            LoadingState() => const Center(
              child: CircularProgressIndicator(color: ThemeDesign.primaryRed),
            ),
            ErrorState(message: final msg) => ErrorViewWidget(
              message: msg,
              onRetry: () {
                pokemonsViewModel.loadPokemon();
              },
            ),
            SuccessState() => PokemonsGridViewWidget(
              pokemonsViewModel: pokemonsViewModel,
            ),
          };
        },
      ),
    );
  }
}
