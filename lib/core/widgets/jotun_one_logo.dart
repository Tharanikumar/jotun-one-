import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class JotunOneLogoWidget extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showTagline;

  const JotunOneLogoWidget({
    super.key,
    this.size = 140.0,
    this.showText = true,
    this.showTagline = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size * 1.8,
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
    );
  }
}
