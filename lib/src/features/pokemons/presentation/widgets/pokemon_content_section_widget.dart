import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';
import 'package:poke_app/src/common/patterns/app_state_pattern.dart';
import 'package:poke_app/src/common/state_management/state_management.dart';
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
      onRefresh: pokemonsViewModel.loadPokemon,
      child: StateBuilderWidget<PokemonsViewModel, PokemonState>(
        viewModel: pokemonsViewModel,
        builder: (context, pokemonState) {
          return switch (pokemonState) {
            InitialState() => const Center(
              child: Text('Pressione para carregar'),
            ),
            LoadingState() => const Center(
              child: CircularProgressIndicator(color: ThemeDesign.primaryRed),
            ),
            ErrorState(error: final e) => ErrorViewWidget(
              message: e.message,
              onRetry: pokemonsViewModel.loadPokemon,
            ),
            SuccessState(data: final pokemonList) => PokemonsGridViewWidget(
              pokemonList: pokemonList,
            ),
          };
        },
      ),
    );
  }
}
