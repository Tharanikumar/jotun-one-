import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Employee Profile Header
          Container(
            padding: const EdgeInsets.only(top: 54, bottom: 20, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF2563EB), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage('assets/images/penguin_ai_assistant.png'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tharani Kumar', style: AppTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Text('Operations Specialist', style: AppTypography.bodySmall.copyWith(color: Colors.white.withAlpha(200))),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.white.withAlpha(50), borderRadius: BorderRadius.circular(6)),
                        child: const Text('ID: JOT-88241', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Menu Items List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                _drawerItem(context, Icons.auto_awesome, 'AI Assistant', '/app/ai-assistant', isHighlighted: true),
                _drawerItem(context, Icons.task_alt_rounded, 'My Tasks', '/app/dashboard'),
                _drawerItem(context, Icons.calendar_month_rounded, 'Leave & Attendance', '/app/leave'),
                _drawerItem(context, Icons.receipt_long_rounded, 'Payroll & Payslips', '/app/dashboard'),
                _drawerItem(context, Icons.headset_mic_rounded, 'IT Support Desk', '/app/helpdesk'),
                _drawerItem(context, Icons.article_rounded, 'HR Policies', '/app/leave'),
                _drawerItem(context, Icons.shield_rounded, 'Safety Hub', '/app/safety'),
                _drawerItem(context, Icons.inventory_2_rounded, 'Warehouse', '/app/warehouse'),
                _drawerItem(context, Icons.precision_manufacturing_rounded, 'Production', '/app/production'),
                const Divider(indent: 20, endIndent: 20, height: 20),
                _drawerItem(context, Icons.notifications_rounded, 'Notifications', '/app/notifications'),
                _drawerItem(context, Icons.bookmark_border_rounded, 'Saved Bookmarks', '/app/ai-assistant'),
                _drawerItem(context, Icons.history_rounded, 'Conversation History', '/app/ai-assistant'),
                const Divider(indent: 20, endIndent: 20, height: 20),
                _drawerItem(context, Icons.settings_rounded, 'Settings', '/app/profile'),
                _drawerItem(context, Icons.help_outline_rounded, 'Help & Support', '/app/helpdesk'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String label, String route, {bool isHighlighted = false}) {
    return ListTile(
      leading: Icon(icon, color: isHighlighted ? AppColors.primary : AppColors.textSecondary, size: 22),
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(
          color: isHighlighted ? AppColors.primary : AppColors.navyDark,
          fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      dense: true,
      horizontalTitleGap: 12,
      onTap: () {
        Navigator.pop(context);
        context.push(route);
      },
    );
  }
}
