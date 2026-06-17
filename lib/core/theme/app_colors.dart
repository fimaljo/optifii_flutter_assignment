import 'package:flutter/material.dart';

abstract final class AppColors {
  // Figma dark theme palette
  static const background = Color(0xFF0F0F1A);
  static const backgroundGradientEnd = Color(0xFF1A1A2E);
  static const surface = Color(0xFF252542);
  static const surfaceLight = Color(0xFF2E2E4A);
  static const surfaceElevated = Color(0xFF353555);

  static const primary = Color(0xFF3B82F6);
  static const primaryDark = Color(0xFF2563EB);
  static const primaryGlow = Color(0xFF60A5FA);

  static const accent = Color(0xFF22C55E);
  static const accentLight = Color(0x3322C55E);
  static const orange = Color(0xFFF97316);
  static const orangeLight = Color(0x33F97316);
  static const pink = Color(0xFFEC4899);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB4B4C8);
  static const textTertiary = Color(0xFF7A7A94);
  static const border = Color(0xFF3A3A58);
  static const divider = Color(0xFF2A2A42);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);

  static const heroGradientStart = Color(0xFF6366F1);
  static const heroGradientEnd = Color(0xFF8B5CF6);
  static const giftGradientStart = Color(0xFFDB2777);
  static const giftGradientEnd = Color(0xFF9333EA);

  static const brandColors = <String, Color>{
    'flipkart': Color(0xFF2874F0),
    'amazon': Color(0xFFFF9900),
    'swiggy': Color(0xFFFC8019),
    'zomato': Color(0xFFE23744),
    'myntra': Color(0xFFFF3F6C),
    'nykaa': Color(0xFFFC2779),
    'bigbasket': Color(0xFF84C225),
    'dominos': Color(0xFF006491),
    'lifestyle': Color(0xFFED1C24),
  };

  static LinearGradient get backgroundGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [background, backgroundGradientEnd],
      );
}
