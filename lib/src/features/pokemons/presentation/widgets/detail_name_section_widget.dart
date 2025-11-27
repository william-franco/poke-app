import 'package:flutter/material.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';

class DetailNameSectionWidget extends StatelessWidget {
  final PokemonEntity pokemon;
  final Color typeColor;

  const DetailNameSectionWidget({
    super.key,
    required this.pokemon,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.catching_pokemon, color: typeColor, size: 24),
          const SizedBox(width: 12),
          Text(
            pokemon.name ?? 'Desconhecido',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: typeColor,
            ),
          ),
        ],
      ),
    );
  }
}
