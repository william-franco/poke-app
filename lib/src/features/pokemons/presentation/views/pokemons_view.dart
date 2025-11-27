import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';
import 'package:poke_app/src/common/widgets/pokedex_header_widget.dart';
import 'package:poke_app/src/features/pokemons/presentation/view_models/pokemons_view_model.dart';
import 'package:poke_app/src/features/pokemons/presentation/widgets/pokemon_content_section_widget.dart';
import 'package:poke_app/src/features/pokemons/presentation/widgets/search_and_filter_section_widget.dart';

class PokemonsView extends StatefulWidget {
  final PokemonsViewModel pokemonsViewModel;

  const PokemonsView({super.key, required this.pokemonsViewModel});

  @override
  State<PokemonsView> createState() => _PokemonsViewState();
}

class _PokemonsViewState extends State<PokemonsView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.pokemonsViewModel.loadPokemon();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: ThemeDesign.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              const PokedexHeaderWidget(),
              SearchAndFilterSectionWidget(
                searchController: _searchController,
                pokemonsViewModel: widget.pokemonsViewModel,
              ),
              Expanded(
                child: PokemonContentSectionWidget(
                  pokemonsViewModel: widget.pokemonsViewModel,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
