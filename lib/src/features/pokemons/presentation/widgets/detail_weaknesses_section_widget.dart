import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';
import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/common/widgets/type_chip_widget.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';

class DetailWeaknessesSectionWidget extends StatelessWidget {
  const DetailWeaknessesSectionWidget({super.key, required this.pokemon});

  final PokemonEntity pokemon;

  String _getTypeString(Type type) {
    return typeValues.reverse[type] ?? type.name;
  }

  @override
  Widget build(BuildContext context) {
    final weaknesses = pokemon.weaknesses ?? [];

    if (weaknesses.isEmpty) {
      return const Text(
        'Nenhuma fraqueza definida',
        style: TextStyle(color: ThemeDesign.textSecondary),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: weaknesses.map((weakness) {
        return TypeChipWidget(
          type: _getTypeString(weakness),
          isSmall: false,
          isWeakness: true,
        );
      }).toList(),
    );
  }
}
