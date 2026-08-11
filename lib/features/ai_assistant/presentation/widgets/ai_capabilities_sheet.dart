import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class AiCapabilitiesSheet extends StatefulWidget {
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
  State<AiCapabilitiesSheet> createState() => _AiCapabilitiesSheetState();
}

class _AiCapabilitiesSheetState extends State<AiCapabilitiesSheet> {
  final TextEditingController _searchController = TextEditingController();
  String _filterQuery = '';

  final List<Map<String, dynamic>> _capabilities = [
    {
      'title': 'Leave & Attendance',
      'subtitle': 'Apply leave, check balance & attendance telemetry',
      'icon': Icons.calendar_month_rounded,
      'color': const Color(0xFF2563EB),
      'gradient': const [Color(0xFF2563EB), Color(0xFF3B82F6)],
      'badge': 'Instant Apply',
      'query': 'How many casual leaves do I have?',
    },
    {
      'title': 'Payslip & Salary',
      'subtitle': 'View monthly payslips & tax breakdowns securely',
      'icon': Icons.receipt_long_rounded,
      'color': const Color(0xFF8B5CF6),
      'gradient': const [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
      'badge': 'Encrypted 256-bit',
      'query': 'Show my latest payslip',
    },
    {
      'title': 'IT Support Desk',
      'subtitle': 'Report laptop, VPN & software issues with AI classification',
      'icon': Icons.headset_mic_rounded,
      'color': const Color(0xFF06B6D4),
      'gradient': const [Color(0xFF06B6D4), Color(0xFF22D3EE)],
      'badge': 'Auto-Classify',
      'query': 'My laptop is not working',
    },
    {
      'title': 'Tasks & Priority To-Dos',
      'subtitle': 'View assigned tasks, due dates & overdue alerts',
      'icon': Icons.task_alt_rounded,
      'color': const Color(0xFF10B981),
      'gradient': const [Color(0xFF10B981), Color(0xFF34D399)],
      'badge': 'Live Prioritization',
      'query': 'What tasks do I have today?',
    },
    {
      'title': 'HR Policies & RAG Search',
      'subtitle': 'Search official company policies, handbook & rules',
      'icon': Icons.article_rounded,
      'color': const Color(0xFFF97316),
      'gradient': const [Color(0xFFF97316), Color(0xFFFB923C)],
      'badge': 'Verified Policy',
      'query': 'What is the annual leave policy?',
    },
    {
      'title': 'Employee Profile & Team',
      'subtitle': 'Check employee records, manager info & org directory',
      'icon': Icons.badge_rounded,
      'color': const Color(0xFF3B82F6),
      'gradient': const [Color(0xFF1E40AF), Color(0xFF3B82F6)],
      'badge': 'ID Directory',
      'query': 'Show my employee profile',
    },
    {
      'title': 'Training & EHS Safety',
      'subtitle': 'Access mandatory safety guidelines & plant protocols',
      'icon': Icons.shield_rounded,
      'color': const Color(0xFFEF4444),
      'gradient': const [Color(0xFFDC2626), Color(0xFFF87171)],
      'badge': 'Safety First',
      'query': 'Where can I find safety guidelines?',
    },
    {
      'title': 'Workplace Search',
      'subtitle': 'Index travel policies, forms & plant documents',
      'icon': Icons.manage_search_rounded,
      'color': const Color(0xFF0F172A),
      'gradient': const [Color(0xFF0F172A), Color(0xFF334155)],
      'badge': 'Deep Index',
      'query': 'Find the travel policy',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final filteredList = _capabilities.where((c) {
      if (_filterQuery.isEmpty) return true;
      return (c['title'] as String).toLowerCase().contains(_filterQuery.toLowerCase()) ||
          (c['subtitle'] as String).toLowerCase().contains(_filterQuery.toLowerCase());
    }).toList();

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.82),
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 16, bottom: bottomInset + 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, -6)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.borderLight,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Row with Copilot Version Badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: const Color(0xFF2563EB).withAlpha(80), blurRadius: 10, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Enterprise AI Capabilities', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 17)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(20),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.primary.withAlpha(40)),
                            ),
                            child: const Text('PRO 3.6', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text('Tap any capability to trigger an instant AI copilot workflow', style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search Capability Field
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.navyDark),
                      decoration: const InputDecoration(
                        hintText: 'Search capabilities (e.g. Leave, Payslip, IT)...',
                        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 12),
                        border: InputBorder.none,
                      ),
                      onChanged: (val) => setState(() => _filterQuery = val),
                    ),
                  ),
                  if (_filterQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 16, color: AppColors.textMuted),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _filterQuery = '');
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Capabilities Grid / List View
            Expanded(
              child: ListView.separated(
                itemCount: filteredList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final cap = filteredList[index];
                  final gradientColors = (cap['gradient'] as List<dynamic>).cast<Color>();

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: (cap['color'] as Color).withAlpha(40)),
                      boxShadow: [
                        BoxShadow(
                          color: (cap['color'] as Color).withAlpha(15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          widget.onSelectCapability(cap['query'] as String);
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              // Vibrant 3D Gradient Icon Badge
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: gradientColors,
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: gradientColors[0].withAlpha(80),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(cap['icon'] as IconData, color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 14),

                              // Title, Subtitle & Action Badge
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(cap['title'] as String, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.navyDark)),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: (cap['color'] as Color).withAlpha(15),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(cap['badge'] as String, style: TextStyle(color: cap['color'] as Color, fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      cap['subtitle'] as String,
                                      style: AppTypography.labelSmall.copyWith(color: AppColors.textSecondary, height: 1.25),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: (cap['color'] as Color)),
                            ],
                          ),
                        ),
                      ),
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
