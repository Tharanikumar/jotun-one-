import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withAlpha(20),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const Icon(Icons.person_rounded, size: 50, color: AppColors.primary),
                  ),
                  const SizedBox(height: 12),
                  Text('Tharani Kumar', style: AppTypography.titleLarge),
                  Text('Production Senior Engineer • Emp ID #J1-9842', style: AppTypography.bodySmall),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GlassCard(
              child: Column(
                children: const [
                  ListTile(
                    leading: Icon(Icons.badge_outlined, color: AppColors.primary),
                    title: Text('Employee Identification'),
                    subtitle: Text('ID: J1-9842 • Dept: Production'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.email_outlined, color: AppColors.primary),
                    title: Text('Corporate Email'),
                    subtitle: Text('tharani.kumar@jotun.com'),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.security_rounded, color: AppColors.primary),
                    title: Text('Security & Biometrics'),
                    subtitle: Text('2FA Enabled • Touch ID Active'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Sign Out',
                isGradient: false,
                backgroundColor: AppColors.error.withAlpha(25),
                textColor: AppColors.error,
                onPressed: () => context.go('/login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
