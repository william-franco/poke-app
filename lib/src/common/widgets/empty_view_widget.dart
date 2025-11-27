import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';

class EmptyViewWidget extends StatelessWidget {
  const EmptyViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: ThemeDesign.textLight),
          SizedBox(height: 16),
          Text(
            'Nenhum Pokémon encontrado',
            style: TextStyle(fontSize: 16, color: ThemeDesign.textSecondary),
          ),
        ],
      ),
    );
  }
}
