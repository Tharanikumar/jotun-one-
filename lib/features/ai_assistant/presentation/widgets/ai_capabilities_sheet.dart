import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class AiCapabilitiesSheet extends StatelessWidget {
  final Function(String query) onSelectCapability;

  const AiCapabilitiesSheet({super.key, required this.onSelectCapability});

  static void show(BuildContext context, Function(String query) onSelectCapability) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AiCapabilitiesSheet(onSelectCapability: onSelectCapability),
    );
  }

  @override
  Widget build(BuildContext context) {
    final capabilities = [
      {'title': 'Leave & Attendance', 'subtitle': 'Apply leave, check balance & attendance', 'icon': Icons.calendar_month_rounded, 'color': AppColors.primary, 'query': 'How many casual leaves do I have?'},
      {'title': 'Payslip & Salary', 'subtitle': 'View monthly payslips & tax breakdowns', 'icon': Icons.receipt_long_rounded, 'color': AppColors.accentPurple, 'query': 'Show my latest payslip'},
      {'title': 'IT Support', 'subtitle': 'Report laptop, VPN & software issues', 'icon': Icons.headset_mic_rounded, 'color': AppColors.accentCyan, 'query': 'My laptop is not working'},
      {'title': 'Tasks & To-Dos', 'subtitle': 'View assigned tasks & due dates', 'icon': Icons.task_alt_rounded, 'color': AppColors.accentMint, 'query': 'What tasks do I have today?'},
      {'title': 'HR Policies', 'subtitle': 'Search company rules & guidelines', 'icon': Icons.article_rounded, 'color': AppColors.accentOrange, 'query': 'What is the annual leave policy?'},
      {'title': 'Employee Info', 'subtitle': 'Check profile & team contacts', 'icon': Icons.badge_rounded, 'color': AppColors.info, 'query': 'Show my employee profile'},
      {'title': 'Training & Safety', 'subtitle': 'Access mandatory EHS guidelines', 'icon': Icons.shield_rounded, 'color': AppColors.warning, 'query': 'Where can I find safety guidelines?'},
      {'title': 'Workplace Search', 'subtitle': 'Find policies, handbook & documents', 'icon': Icons.search_rounded, 'color': AppColors.navyDark, 'query': 'Find the travel policy'},
    ];

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), shape: BoxShape.circle),
                child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI Assistant Capabilities', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                  Text('Tap any capability to trigger an instant AI workflow', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          Expanded(
            child: ListView.separated(
              itemCount: capabilities.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final cap = capabilities[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (cap['color'] as Color).withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(cap['icon'] as IconData, color: cap['color'] as Color, size: 22),
                    ),
                    title: Text(cap['title'] as String, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text(cap['subtitle'] as String, style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                    onTap: () {
                      Navigator.pop(context);
                      onSelectCapability(cap['query'] as String);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
    );
  }
}
