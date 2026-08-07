import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand Palette
  static const Color primary = Color(0xFF2563EB); // Vibrant Azure Blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF60A5FA);
  
  static const Color navyDark = Color(0xFF0F172A); // Deep Slate Navy
  static const Color navyMedium = Color(0xFF1E293B);
  
  static const Color accentOrange = Color(0xFFF97316); // Warm Coral / Orange
  static const Color accentCyan = Color(0xFF06B6D4); // Bright Cyan
  static const Color accentPurple = Color(0xFF8B5CF6); // Royal Purple
  static const Color accentMint = Color(0xFF10B981); // Emerald Green

  // Background & Surfaces
  static const Color background = Color(0xFFF8FAFC); // Ice White/Gray
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceTranslucent = Color(0xCCFFFFFF); // Glassmorphism base
  
  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color glassBorder = Color(0x60FFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiBannerGradient = LinearGradient(
    colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFFB923C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0xB3FFFFFF),
      Color(0x80FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
