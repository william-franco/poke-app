import 'package:flutter/material.dart';

class ThemeDesign {
  // Colors
  static const Color primaryRed = Color(0xFFD30A40);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Type Colors
  static const Color grassColor = Color(0xFF4CAF50);
  static const Color poisonColor = Color(0xFF9C27B0);
  static const Color fireColor = Color(0xFFFF9800);
  static const Color waterColor = Color(0xFF2196F3);
  static const Color electricColor = Color(0xFFFFC107);
  static const Color bugColor = Color(0xFF8BC34A);
  static const Color normalColor = Color(0xFF9E9E9E);
  static const Color flyingColor = Color(0xFF9FA8DA);
  static const Color psychicColor = Color(0xFFE91E63);
  static const Color fightingColor = Color(0xFFC62828);
  static const Color rockColor = Color(0xFF795548);
  static const Color groundColor = Color(0xFFA1887F);
  static const Color iceColor = Color(0xFF00BCD4);
  static const Color dragonColor = Color(0xFF673AB7);
  static const Color darkColor = Color(0xFF424242);
  static const Color fairyColor = Color(0xFFF48FB1);
  static const Color ghostColor = Color(0xFF7E57C2);
  static const Color steelColor = Color(0xFF607D8B);

  static Color getTypeColor(String type) {
    return switch (type.toLowerCase()) {
      'grass' => grassColor,
      'poison' => poisonColor,
      'fire' => fireColor,
      'water' => waterColor,
      'electric' => electricColor,
      'bug' => bugColor,
      'normal' => normalColor,
      'flying' => flyingColor,
      'psychic' => psychicColor,
      'fighting' => fightingColor,
      'rock' => rockColor,
      'ground' => groundColor,
      'ice' => iceColor,
      'dragon' => dragonColor,
      'dark' => darkColor,
      'fairy' => fairyColor,
      'ghost' => ghostColor,
      'steel' => steelColor,
      _ => normalColor,
    };
  }
}
