import 'package:flutter/material.dart';
import 'package:poke_app/src/common/widgets/info_card_widget.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';

class DetailPhysicalInfoWidget extends StatelessWidget {
  final PokemonEntity pokemon;
  final Color typeColor;

  const DetailPhysicalInfoWidget({
    super.key,
    required this.pokemon,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InfoCardWidget(
            icon: Icons.height,
            label: 'Altura',
            value: pokemon.height ?? 'N/A',
            color: typeColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: InfoCardWidget(
            icon: Icons.fitness_center,
            label: 'Peso',
            value: pokemon.weight ?? 'N/A',
            color: typeColor,
          ),
        ),
      ],
    );
  }
}
