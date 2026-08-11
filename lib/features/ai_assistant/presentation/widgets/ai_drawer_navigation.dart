import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class AIDrawerNavigation extends StatelessWidget {
  const AIDrawerNavigation({super.key});

  static const List<Map<String, dynamic>> _menuItems = [
    {'title': 'AI Assistant', 'icon': Icons.auto_awesome, 'route': '/app/ai-assistant'},
    {'title': 'My Tasks', 'icon': Icons.check_box_rounded, 'route': '/app/tasks-detail'},
    {'title': 'Leave & Attendance', 'icon': Icons.calendar_month_rounded, 'route': '/app/leave'},
    {'title': 'IT Support', 'icon': Icons.headset_mic_rounded, 'route': '/app/helpdesk'},
    {'title': 'Safety Hub', 'icon': Icons.shield_rounded, 'route': '/app/safety'},
    {'title': 'Warehouse & Logistics', 'icon': Icons.inventory_2_rounded, 'route': '/app/warehouse'},
    {'title': 'Production Operations', 'icon': Icons.precision_manufacturing_rounded, 'route': '/app/production'},
    {'title': 'Notifications', 'icon': Icons.notifications_rounded, 'route': '/app/notifications'},
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header User Info Container
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF1D4ED8),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage('assets/images/penguin_ai_assistant.png'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Tharani Kumar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Senior Specialist • EMP-405',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Navigation Links List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _menuItems.length,
              separatorBuilder: (context, index) => const Divider(height: 1, indent: 20, endIndent: 20, color: Color(0xFFF1F5F9)),
              itemBuilder: (context, index) {
                final item = _menuItems[index];
                return ListTile(
                  leading: Icon(item['icon'] as IconData, color: AppColors.primary, size: 20),
                  title: Text(
                    item['title'] as String,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
                  onTap: () {
                    Navigator.pop(context);
                    context.push(item['route'] as String);
                  },
                );
              },
            ),
          ),

          // Footer
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Icon(Icons.shield_outlined, size: 16, color: Color(0xFF64748B)),
                SizedBox(width: 8),
                Text('Jotun One Enterprise v2.4', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
