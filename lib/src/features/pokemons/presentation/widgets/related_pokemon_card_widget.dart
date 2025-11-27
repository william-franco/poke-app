import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';
import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';

class RelatedPokemonCardWidget extends StatelessWidget {
  final PokemonEntity pokemon;
  final VoidCallback onTap;

  const RelatedPokemonCardWidget({
    super.key,
    required this.pokemon,
    required this.onTap,
  });

  String _getTypeString(Type type) {
    return typeValues.reverse[type] ?? type.name;
  }

  @override
  Widget build(BuildContext context) {
    final types = pokemon.type ?? [];
    final primaryType = types.isNotEmpty ? types.first : Type.NORMAL;
    final typeColor = ThemeDesign.getTypeColor(_getTypeString(primaryType));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: typeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: typeColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                pokemon.img ?? '',
                height: 60,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.catching_pokemon,
                    size: 40,
                    color: typeColor.withValues(alpha: 0.5),
                  );
                },
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  pokemon.name ?? 'Desconhecido',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: ThemeDesign.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                '#${pokemon.num ?? '???'}',
                style: TextStyle(fontSize: 10, color: typeColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
