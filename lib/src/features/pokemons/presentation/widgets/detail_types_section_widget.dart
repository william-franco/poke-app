import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';
import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/common/widgets/type_chip_widget.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';

class DetailTypesSectionWidget extends StatelessWidget {
  final PokemonEntity pokemon;

  const DetailTypesSectionWidget({super.key, required this.pokemon});

  String _getTypeString(Type type) {
    return typeValues.reverse[type] ?? type.name;
  }

  @override
  Widget build(BuildContext context) {
    final types = pokemon.type ?? [];

    if (types.isEmpty) {
      return const Text(
        'Nenhum tipo definido',
        style: TextStyle(color: ThemeDesign.textSecondary),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((type) {
        return TypeChipWidget(type: _getTypeString(type), isSmall: false);
      }).toList(),
    );
  }
}
