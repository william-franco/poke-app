import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';
import 'package:poke_app/src/features/pokemons/presentation/view_models/pokemons_view_model.dart';
import 'package:poke_app/src/features/pokemons/presentation/widgets/related_pokemon_card_widget.dart';

class DetailRelatedSectionWidget extends StatelessWidget {
  final PokemonEntity pokemon;
  final PokemonsViewModel viewModel;
  final Function(PokemonEntity) onRelatedTap;

  const DetailRelatedSectionWidget({
    super.key,
    required this.pokemon,
    required this.viewModel,
    required this.onRelatedTap,
  });

  @override
  Widget build(BuildContext context) {
    final relatedPokemon = viewModel.getRelatedPokemon(pokemon);

    if (relatedPokemon.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Sem evoluções relacionadas',
            style: TextStyle(color: ThemeDesign.textSecondary, fontSize: 14),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: relatedPokemon.length,
      itemBuilder: (context, index) {
        final related = relatedPokemon[index];
        return RelatedPokemonCardWidget(
          pokemon: related,
          onTap: () => onRelatedTap(related),
        );
      },
    );
  }
}
