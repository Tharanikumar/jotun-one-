import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        title: Text(
          'Profile',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            // Avatar Showcase with Ring & "Senior" Pro Badge
            Center(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Outer Ambient Glow Ring
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const SweepGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.accentCyan,
                          AppColors.accentPurple,
                          AppColors.primary,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(40),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                  ),

                  // Inner White Gap Ring
                  Container(
                    width: 112,
                    height: 112,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),

                  // Profile Avatar Center
                  Container(
                    width: 104,
                    height: 104,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                  ),

                  // "Senior" Pro Badge Pill at Bottom Center
                  Positioned(
                    bottom: -8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(80),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        'Senior Eng',
                        style: AppTypography.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // User Name & Email Subtitle
            Text(
              'Tharani Kumar',
              style: AppTypography.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'tharani.kumar@jotun.com',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textMuted,
              ),
            ),

            const SizedBox(height: 28),

            // 2x2 Quick Info Stat Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.6,
              children: const [
                _ProfileInfoCard(
                  icon: Icons.badge_rounded,
                  iconColor: AppColors.primary,
                  label: 'Department',
                  value: 'Production',
                ),
                _ProfileInfoCard(
                  icon: Icons.work_history_rounded,
                  iconColor: AppColors.accentPurple,
                  label: 'Role',
                  value: 'Senior Eng',
                ),
                _ProfileInfoCard(
                  icon: Icons.verified_user_rounded,
                  iconColor: AppColors.accentMint,
                  label: 'Employee ID',
                  value: 'J1-9842',
                ),
                _ProfileInfoCard(
                  icon: Icons.fingerprint_rounded,
                  iconColor: AppColors.accentOrange,
                  label: 'Security',
                  value: '2FA Active',
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action Items List
            _ProfileActionTile(
              icon: Icons.security_rounded,
              iconColor: AppColors.primary,
              title: 'Account & Security Settings',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _ProfileActionTile(
              icon: Icons.notifications_none_rounded,
              iconColor: AppColors.accentPurple,
              title: 'Notification Preferences',
              onTap: () {},
            ),
            const SizedBox(height: 12),
            _ProfileActionTile(
              icon: Icons.description_outlined,
              iconColor: AppColors.accentCyan,
              title: 'Company Policies & EHS Guidelines',
              onTap: () {},
            ),
            const SizedBox(height: 12),

            // Sign Out Red Action Tile
            _ProfileActionTile(
              icon: Icons.logout_rounded,
              iconColor: AppColors.error,
              title: 'Sign Out',
              textColor: AppColors.error,
              isDestructive: true,
              onTap: () {
                HapticFeedback.lightImpact();
                context.go('/login');
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _ProfileInfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      borderRadius: 20,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Color? textColor;
  final bool isDestructive;
  final VoidCallback onTap;

  const _ProfileActionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.textColor,
    this.isDestructive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      borderRadius: 20,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDestructive ? AppColors.error.withAlpha(20) : iconColor.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isDestructive ? AppColors.error : iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: textColor ?? AppColors.textPrimary,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: isDestructive ? AppColors.error.withAlpha(150) : AppColors.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}
