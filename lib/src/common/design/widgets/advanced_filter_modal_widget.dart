import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';

class AdvancedFilterModalWidget extends StatelessWidget {
  final List<String> availableTypes;
  final String? selectedType;
  final Function(String?) onTypeSelected;
  final VoidCallback onClearFilters;

  const AdvancedFilterModalWidget({
    super.key,
    required this.availableTypes,
    this.selectedType,
    required this.onTypeSelected,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtro Avançado',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: ThemeDesign.textPrimary,
                ),
              ),
              TextButton(
                onPressed: onClearFilters,
                child: const Text(
                  'Limpar',
                  style: TextStyle(color: ThemeDesign.primaryRed),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Filtrar por tipo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ThemeDesign.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          // Type Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableTypes.map((type) {
              final isSelected = selectedType == type;
              final color = ThemeDesign.getTypeColor(type);

              return GestureDetector(
                onTap: () => onTypeSelected(isSelected ? null : type),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? color : color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color, width: isSelected ? 2 : 1),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
