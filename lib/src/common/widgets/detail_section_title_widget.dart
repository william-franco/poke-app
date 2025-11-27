import 'package:flutter/material.dart';
import 'package:poke_app/src/common/design/theme_design.dart';

class DetailSectionTitleWidget extends StatelessWidget {
  final String title;

  const DetailSectionTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: ThemeDesign.textPrimary,
        ),
      ),
    );
  }
}
