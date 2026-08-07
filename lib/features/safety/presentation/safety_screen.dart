import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Safety & EHS Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Report an Incident', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _SafetyCategoryTile(title: 'Unsafe Act', icon: Icons.warning_amber_rounded, color: AppColors.warning),
                _SafetyCategoryTile(title: 'Unsafe Condition', icon: Icons.report_problem_rounded, color: AppColors.accentOrange),
                _SafetyCategoryTile(title: 'Near Miss', icon: Icons.error_outline_rounded, color: AppColors.accentPurple),
                _SafetyCategoryTile(title: 'Accident', icon: Icons.dangerous_rounded, color: AppColors.error),
              ],
            ),
            const SizedBox(height: 28),
            Text('Recent Reports', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                children: const [
                  ListTile(
                    leading: CircleAvatar(backgroundColor: Color(0x20F97316), child: Icon(Icons.warning, color: AppColors.accentOrange)),
                    title: Text('Near Miss in Chemical Storage'),
                    subtitle: Text('23 May 2024 • Under Review'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(),
                  ListTile(
                    leading: CircleAvatar(backgroundColor: Color(0x2010B981), child: Icon(Icons.check_circle, color: AppColors.success)),
                    title: Text('Unsafe Condition Fixed'),
                    subtitle: Text('22 May 2024 • Resolved'),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SafetyCategoryTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SafetyCategoryTile({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(height: 8),
          Text(title, style: AppTypography.labelLarge),
        ],
      ),
    );
  }
}
