import 'package:flutter/material.dart';

abstract final class AppColors {
  static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1D4ED8);
  static const primaryLight = Color(0xFFDBEAFE);
  static const accent = Color(0xFF10B981);
  static const accentLight = Color(0xFFD1FAE5);
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textTertiary = Color(0xFF94A3B8);
  static const border = Color(0xFFE2E8F0);
  static const divider = Color(0xFFF1F5F9);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const shadow = Color(0x1A0F172A);

  static const brandColors = <String, Color>{
    'flipkart': Color(0xFF2874F0),
    'amazon': Color(0xFFFF9900),
    'swiggy': Color(0xFFFC8019),
    'zomato': Color(0xFFE23744),
    'myntra': Color(0xFFFF3F6C),
    'nykaa': Color(0xFFFC2779),
    'bigbasket': Color(0xFF84C225),
    'dominos': Color(0xFF006491),
  };
}
