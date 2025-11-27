import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';

class SortButtonWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const SortButtonWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: isSelected ? ThemeDesign.darkColor : Colors.white,
        foregroundColor: isSelected ? Colors.white : ThemeDesign.textSecondary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: isSelected ? 2 : 0,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
