import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback? onTap;
  final List<BoxShadow>? shadows;
  final double blurAmount;
  final LinearGradient? customGradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 24.0,
    this.backgroundColor,
    this.borderColor,
    this.onTap,
    this.shadows,
    this.blurAmount = 16.0,
    this.customGradient,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveShadows = shadows ??
        [
          const BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.primary.withAlpha(12),
            blurRadius: 16,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ];

    Widget cardBody = Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: backgroundColor == null
            ? (customGradient ??
                LinearGradient(
                  colors: [
                    Colors.white.withAlpha(225),
                    Colors.white.withAlpha(165),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ))
            : null,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? Colors.white,
          width: 1.5,
        ),
      ),
      child: child,
    );

    Widget frostedGlass = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: effectiveShadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
          child: onTap != null
              ? Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(borderRadius),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(borderRadius),
                    splashColor: AppColors.primary.withAlpha(20),
                    highlightColor: AppColors.primary.withAlpha(10),
                    child: cardBody,
                  ),
                )
              : cardBody,
        ),
      ),
    );

    return frostedGlass;
  }
}
