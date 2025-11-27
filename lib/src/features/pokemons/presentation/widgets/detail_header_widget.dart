import 'package:flutter/material.dart';
import 'package:poke_app/src/common/widgets/circle_pattern_painter_widget.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';

class DetailHeaderWidget extends StatelessWidget {
  final PokemonEntity pokemon;
  final Color typeColor;

  const DetailHeaderWidget({
    super.key,
    required this.pokemon,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [typeColor.withOpacity(0.2), typeColor.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: CirclePatternPainterWidget(typeColor)),
          ),
          Center(
            child: Hero(
              tag: 'pokemon_${pokemon.id ?? 0}',
              child: Image.network(
                pokemon.img ?? '',
                height: 160,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.catching_pokemon,
                    size: 100,
                    color: typeColor.withOpacity(0.5),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: typeColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '#${pokemon.num ?? '???'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
