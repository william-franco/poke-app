import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';
import 'package:poke_app/src/common/enums/pokemons_enums.dart';
import 'package:poke_app/src/common/widgets/type_chip_widget.dart';
import 'package:poke_app/src/features/pokemons/domain/entities/pokemon_entity.dart';

class PokemonCardWidget extends StatelessWidget {
  final PokemonEntity pokemon;
  final VoidCallback onTap;

  const PokemonCardWidget({
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

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: typeColor.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image Container
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      typeColor.withValues(alpha: 0.1),
                      typeColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    // Pokemon Number
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Text(
                        '#${pokemon.num ?? '???'}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: typeColor.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                    // Pokemon Image
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.network(
                          pokemon.img ?? '',
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: typeColor,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.catching_pokemon,
                              size: 40,
                              color: typeColor.withValues(alpha: 0.5),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Info Container
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pokemon.name ?? 'Desconhecido',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ThemeDesign.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Type Chips
                    Wrap(
                      spacing: 4,
                      runSpacing: 2,
                      alignment: WrapAlignment.center,
                      children: types.take(2).map((type) {
                        return TypeChipWidget(
                          type: _getTypeString(type),
                          isSmall: true,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
