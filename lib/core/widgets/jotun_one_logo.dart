import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class JotunOneLogoWidget extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showTagline;

  const JotunOneLogoWidget({
    super.key,
    this.size = 100.0,
    this.showText = true,
    this.showTagline = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Official J1 Orbital Factory Badge
        SizedBox(
          width: size,
          height: size,
          child: Image.asset(
            'assets/images/jotun_one_logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    'J1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 14),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'JOTUN',
                style: AppTypography.displayMedium.copyWith(
                  color: AppColors.navyDark,
                  fontSize: size * 0.26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 8),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFF97316), Color(0xFFFF6B00)],
                ).createShader(bounds),
                child: Text(
                  'ONE',
                  style: AppTypography.displayMedium.copyWith(
                    color: Colors.white,
                    fontSize: size * 0.26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (showTagline) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 24, height: 1.5, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'ENGINEERED SOLUTIONS',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 8),
              Container(width: 24, height: 1.5, color: AppColors.accentOrange),
            ],
          ),
        ],
      ],
    );
  }
}
