import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/models.dart';

class BrandAvatar extends StatelessWidget {
  const BrandAvatar({
    super.key,
    required this.brand,
    this.size = 48,
    this.fontSize,
  });

  final Brand brand;
  final double size;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.brandColors[brand.id] ?? AppColors.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.25),
      ),
      alignment: Alignment.center,
      child: Text(
        brand.name.characters.first.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: fontSize ?? size * 0.38,
        ),
      ),
    );
  }
}
