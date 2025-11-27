import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';

class DetailStatsSectionWidget extends StatelessWidget {
  final PokemonEntity pokemon;
  final Color typeColor;

  const DetailStatsSectionWidget({
    super.key,
    required this.pokemon,
    required this.typeColor,
  });

  Color _getStatColor(double percentage) {
    if (percentage < 0.3) return Colors.red;
    if (percentage < 0.5) return Colors.orange;
    if (percentage < 0.7) return Colors.yellow[700]!;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final pokemonId = pokemon.id ?? 1;

    final stats = [
      {'name': 'HP', 'value': (45 + pokemonId * 3).clamp(0, 255), 'max': 255},
      {
        'name': 'Ataque',
        'value': (49 + pokemonId * 2).clamp(0, 190),
        'max': 190,
      },
      {
        'name': 'Defesa',
        'value': (49 + pokemonId * 2).clamp(0, 230),
        'max': 230,
      },
      {
        'name': 'Atq. Esp.',
        'value': (65 + pokemonId * 2).clamp(0, 194),
        'max': 194,
      },
      {
        'name': 'Def. Esp.',
        'value': (65 + pokemonId * 2).clamp(0, 230),
        'max': 230,
      },
      {
        'name': 'Velocidade',
        'value': (45 + pokemonId * 2).clamp(0, 180),
        'max': 180,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: stats.map((stat) {
          final value = stat['value'] as int;
          final max = stat['max'] as int;
          final percentage = value / max;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    stat['name'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ThemeDesign.textSecondary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: Text(
                    value.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ThemeDesign.textPrimary,
                    ),
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getStatColor(percentage),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
