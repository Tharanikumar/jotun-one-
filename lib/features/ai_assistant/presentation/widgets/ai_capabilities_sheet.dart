import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AICapabilitiesSheet extends StatelessWidget {
  final Function(String query)? onSelectCapability;

  const AICapabilitiesSheet({super.key, this.onSelectCapability});

  static const List<Map<String, dynamic>> _capabilities = [
    {
      'title': 'Leave & Attendance',
      'subtitle': 'Apply leave, check balances, view logs',
      'icon': Icons.calendar_month_rounded,
      'color': Color(0xFF2563EB),
      'bgColor': Color(0xFFEFF6FF),
      'query': 'How many leaves do I have?',
    },
    {
      'title': 'Payslip & Salary',
      'subtitle': 'Secure net salary & earnings breakdown',
      'icon': Icons.receipt_long_rounded,
      'color': Color(0xFF10B981),
      'bgColor': Color(0xFFECFDF5),
      'query': 'Show my latest payslip',
    },
    {
      'title': 'IT Support',
      'subtitle': 'Troubleshoot & create IT tickets',
      'icon': Icons.headset_mic_rounded,
      'color': Color(0xFF8B5CF6),
      'bgColor': Color(0xFFF5F3FF),
      'query': 'My laptop is not working',
    },
    {
      'title': 'Tasks & To-Dos',
      'subtitle': 'Manage assigned priority tasks',
      'icon': Icons.check_box_rounded,
      'color': Color(0xFFF59E0B),
      'bgColor': Color(0xFFFFF7ED),
      'query': 'What tasks are assigned to me?',
    },
    {
      'title': 'HR Policies',
      'subtitle': 'Official leave, WFH & overtime rules',
      'icon': Icons.menu_book_rounded,
      'color': Color(0xFF06B6D4),
      'bgColor': Color(0xFFECFEFF),
      'query': 'What is the work from home policy?',
    },
    {
      'title': 'Workplace Search',
      'subtitle': 'Search documents & employee hub',
      'icon': Icons.manage_search_rounded,
      'color': Color(0xFF6366F1),
      'bgColor': Color(0xFFEEF2FF),
      'query': 'Find the safety training document',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Icon(Icons.auto_awesome, color: Color(0xFF7C3AED), size: 22),
              SizedBox(width: 8),
              Text(
                'AI Assistant Capabilities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Tap any capability to quickly trigger an action or query:',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 18),
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: _capabilities.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final item = _capabilities[index];
                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onSelectCapability?.call(item['query'] as String);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item['bgColor'] as Color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: (item['color'] as Color).withAlpha(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          color: item['color'] as Color,
                          size: 24,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          item['title'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item['subtitle'] as String,
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
