import 'package:flutter/material.dart';

abstract class AppShadows {
  static const List<BoxShadow> softCard = [
    BoxShadow(
      color: Color(0x0C0F172A),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x050F172A),
      blurRadius: 4,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> floatingGlass = [
    BoxShadow(
      color: Color(0x1A0F172A),
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0A2563EB),
      blurRadius: 12,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: Color(0x402563EB),
      blurRadius: 16,
      offset: Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> fabShadow = [
    BoxShadow(
      color: Color(0x4D2563EB),
      blurRadius: 20,
      offset: Offset(0, 8),
      spreadRadius: 2,
    ),
  ];
}
