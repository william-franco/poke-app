import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/src/common/design/theme_design.dart';
import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/common/widgets/detail_section_title_widget.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/presentation/routes/pokemons_routes.dart';
import 'package:poke_app/src/features/pokemons/presentation/view_models/pokemons_view_model.dart';
import 'package:poke_app/src/features/pokemons/presentation/widgets/detail_header_widget.dart';
import 'package:poke_app/src/features/pokemons/presentation/widgets/detail_name_section_widget.dart';
import 'package:poke_app/src/features/pokemons/presentation/widgets/detail_physical_info_widget.dart';
import 'package:poke_app/src/features/pokemons/presentation/widgets/detail_related_section_widget.dart';
import 'package:poke_app/src/features/pokemons/presentation/widgets/detail_stats_section_widget.dart';
import 'package:poke_app/src/features/pokemons/presentation/widgets/detail_types_section_widget.dart';
import 'package:poke_app/src/features/pokemons/presentation/widgets/detail_weaknesses_section_widget.dart';

class PokemonDetailView extends StatefulWidget {
  final PokemonEntity pokemon;
  final PokemonsViewModel viewModel;

  const PokemonDetailView({
    super.key,
    required this.pokemon,
    required this.viewModel,
  });

  @override
  State<PokemonDetailView> createState() => _PokemonDetailViewState();
}

class _PokemonDetailViewState extends State<PokemonDetailView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.logPokemonDetailView(widget.pokemon);
    });
  }

  String _getTypeString(Type type) {
    return typeValues.reverse[type] ?? type.name;
  }

  @override
  Widget build(BuildContext context) {
    final types = widget.pokemon.type ?? [];
    final primaryType = types.isNotEmpty ? types.first : Type.NORMAL;
    final typeColor = ThemeDesign.getTypeColor(_getTypeString(primaryType));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                // DRAG HANDLE
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // HEADER
                DetailHeaderWidget(
                  pokemon: widget.pokemon,
                  typeColor: typeColor,
                ),

                const SizedBox(height: 24),

                // NAME
                DetailNameSectionWidget(
                  pokemon: widget.pokemon,
                  typeColor: typeColor,
                ),

                const SizedBox(height: 24),

                // TYPES
                const DetailSectionTitleWidget(title: 'Tipos'),
                DetailTypesSectionWidget(pokemon: widget.pokemon),

                const SizedBox(height: 24),

                // STATS
                const DetailSectionTitleWidget(title: 'Status Base'),
                DetailStatsSectionWidget(
                  pokemon: widget.pokemon,
                  typeColor: typeColor,
                ),

                const SizedBox(height: 24),

                // PHYSICAL INFO
                const DetailSectionTitleWidget(title: 'Informações Físicas'),
                DetailPhysicalInfoWidget(
                  pokemon: widget.pokemon,
                  typeColor: typeColor,
                ),

                const SizedBox(height: 24),

                // WEAKNESSES
                const DetailSectionTitleWidget(title: 'Fraquezas'),
                DetailWeaknessesSectionWidget(pokemon: widget.pokemon),

                const SizedBox(height: 24),

                const DetailSectionTitleWidget(
                  title: 'Relacionados / Evoluções',
                ),
                DetailRelatedSectionWidget(
                  pokemon: widget.pokemon,
                  viewModel: widget.viewModel,
                  onRelatedTap: (related) {
                    widget.viewModel.logEvolutionView(widget.pokemon, related);

                    context.pop();

                    Future.delayed(const Duration(milliseconds: 250), () {
                      context.push(
                        PokemonsRoutes.pokemonDetail,
                        extra: related,
                      );
                    });
                  },
                ),

                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }
}
