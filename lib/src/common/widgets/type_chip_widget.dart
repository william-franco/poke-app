import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';

class TypeChipWidget extends StatelessWidget {
  final String type;
  final bool isSmall;
  final bool isWeakness;

  const TypeChipWidget({
    super.key,
    required this.type,
    required this.isSmall,
    this.isWeakness = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = ThemeDesign.getTypeColor(type);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 16,
        vertical: isSmall ? 4 : 8,
      ),
      decoration: BoxDecoration(
        color: isWeakness ? color.withOpacity(0.15) : color,
        borderRadius: BorderRadius.circular(isSmall ? 8 : 20),
        border: isWeakness ? Border.all(color: color, width: 1.5) : null,
      ),
      child: Text(
        type,
        style: TextStyle(
          color: isWeakness ? color : Colors.white,
          fontSize: isSmall ? 10 : 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
