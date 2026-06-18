import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Figma global screen gradient — vibrant royal purple top → near-black bottom.
  /// Reference: Rewards Search / all screens in Flutter Round 2 Figma.
  static const gradientTop = Color(0xFF5E17EB);
  static const gradientMid = Color(0xFF2A0A52);
  static const gradientBottom = Color(0xFF0A0014);

  static const background = gradientTop;
  static const backgroundGradientEnd = gradientBottom;

  // Glass / translucent UI on gradient
  static const glassFill = Color(0x1AFFFFFF);
  static const glassBorder = Color(0x33FFFFFF);
  static const chipFill = Color(0x26FFFFFF);

  static const surface = Color(0xFF1A0D30);
  static const surfaceLight = Color(0xFF241240);
  static const surfaceElevated = Color(0xFF2E1650);
  static const cardFooter = Color(0xFF120822);

  static const primary = Color(0xFF7C3AED);
  static const primaryDark = Color(0xFF5E17EB);
  static const link = Color(0xFFC4B5FD);
static const brandCardBackground = Color.fromARGB(142, 20, 7, 38);
  static const discountGreen = Color(0xFF4ADE80);
  static const accent = discountGreen;
  static const accentLight = Color(0x334ADE80);
  static const orange = Color(0xFFF97316);
  static const orangeLight = Color(0x33F97316);
  static const pink = Color(0xFFEC4899);
  static const makeMyTripBlue = Color(0xFF008CFF);
  static const makeMyTripRed = Color(0xFFE53935);

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFD8D0E8);
  static const textHint = Color(0xFFB0A4C8);
  static const textTertiary = Color(0xFF8A7FA0);
  static const border = Color(0x33FFFFFF);
  static const divider = Color(0xFF241240);
  static const error = Color(0xFFEF4444);

  static const optifiiPurple = Color(0xFF6D28D9);
  static const optifiiPurpleDark = Color(0xFF4C1D95);

  static const brandColors = <String, Color>{
    'flipkart': Color(0xFF2874F0),
    'amazon': Color(0xFF232F3E),
    'swiggy': Color(0xFFFC8019),
    'zomato': Color(0xFFE23744),
    'myntra': Color(0xFFFF3F6C),
    'nykaa': Color(0xFFFC2779),
    'bigbasket': Color(0xFF84C225),
    'dominos': Color(0xFF006491),
    'lifestyle': Color(0xFFFFFFFF),
  };

  static const brandLogoColors = <String, Color>{
    'flipkart': Color(0xFFFFE500),
    'amazon': Color(0xFFFF9900),
    'swiggy': Color(0xFFFFFFFF),
    'lifestyle': Color(0xFFED1C24),
    'bigbasket': Color(0xFFFFFFFF),
  };

  static LinearGradient get backgroundGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [gradientTop, gradientMid, gradientBottom],
        stops: [0.0, 0.42, 1.0],
      );
}
