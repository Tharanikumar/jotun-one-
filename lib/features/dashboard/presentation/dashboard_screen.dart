import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/apple_dock_magnifier.dart';
import '../../../core/widgets/quick_access_tile.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. User Header & Notification Bell
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withAlpha(20),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.person_rounded, color: AppColors.primary, size: 28),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Good Morning,',
                                style: AppTypography.bodyMedium,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'Tharani Kumar 👋',
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Production Department',
                            style: AppTypography.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                          onPressed: () => context.push('/app/notifications'),
                        ),
                      ),
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: const Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 2. Today's Overview Section Header
              SectionHeader(
                title: "Today's Overview",
                actionText: 'View All',
                onActionTap: () {},
              ),
              const SizedBox(height: 12),

              // 4 KPI Metric Cards with Apple macOS Dock Magnification
              AppleDockMagnifierRow(
                children: [
                  StatCard(
                    title: 'Tasks',
                    value: '12',
                    icon: Icons.assignment_turned_in_rounded,
                    iconBgColor: AppColors.primary.withAlpha(20),
                    iconColor: AppColors.primary,
                    heroTag: 'hero_tasks',
                    onTap: () => context.push('/app/tasks'),
                  ),
                  StatCard(
                    title: 'Approvals',
                    value: '05',
                    icon: Icons.verified_user_rounded,
                    iconBgColor: AppColors.accentMint.withAlpha(20),
                    iconColor: AppColors.accentMint,
                    heroTag: 'hero_approvals',
                    onTap: () => context.push('/app/approvals'),
                  ),
                  StatCard(
                    title: 'Tickets',
                    value: '03',
                    icon: Icons.confirmation_number_rounded,
                    iconBgColor: AppColors.accentPurple.withAlpha(20),
                    iconColor: AppColors.accentPurple,
                    heroTag: 'hero_tickets',
                    onTap: () => context.push('/app/helpdesk'),
                  ),
                  StatCard(
                    title: 'Alerts',
                    value: '02',
                    icon: Icons.notifications_active_rounded,
                    iconBgColor: AppColors.accentOrange.withAlpha(20),
                    iconColor: AppColors.accentOrange,
                    heroTag: 'hero_alerts',
                    onTap: () => context.push('/app/notifications'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. AI Assistant Banner Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.aiBannerGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x332563EB),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withAlpha(50),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'AI ASSISTANT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your smart workplace assistant',
                            style: AppTypography.titleMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => context.push('/app/ai-assistant'),
                            icon: const Icon(Icons.auto_awesome, size: 16, color: AppColors.primary),
                            label: const Text('Ask Now →'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              textStyle: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.smart_toy_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // 4. Quick Access Shortcuts Grid
              const SectionHeader(title: 'Quick Access'),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: [
                  QuickAccessTile(
                    label: 'IT Helpdesk',
                    icon: Icons.support_agent_rounded,
                    iconColor: AppColors.primary,
                    backgroundColor: AppColors.primary.withAlpha(15),
                    onTap: () => context.push('/app/helpdesk'),
                  ),
                  QuickAccessTile(
                    label: 'Leave',
                    icon: Icons.event_note_rounded,
                    iconColor: AppColors.accentMint,
                    backgroundColor: AppColors.accentMint.withAlpha(15),
                    onTap: () => context.push('/app/leave'),
                  ),
                  QuickAccessTile(
                    label: 'Attendance',
                    icon: Icons.access_time_filled_rounded,
                    iconColor: AppColors.accentPurple,
                    backgroundColor: AppColors.accentPurple.withAlpha(15),
                    onTap: () {},
                  ),
                  QuickAccessTile(
                    label: 'Announce',
                    icon: Icons.campaign_rounded,
                    iconColor: AppColors.accentOrange,
                    backgroundColor: AppColors.accentOrange.withAlpha(15),
                    onTap: () {},
                  ),
                  QuickAccessTile(
                    label: 'Assets',
                    icon: Icons.devices_rounded,
                    iconColor: AppColors.accentCyan,
                    backgroundColor: AppColors.accentCyan.withAlpha(15),
                    onTap: () {},
                  ),
                  QuickAccessTile(
                    label: 'Payslip',
                    icon: Icons.receipt_long_rounded,
                    iconColor: AppColors.primary,
                    backgroundColor: AppColors.primary.withAlpha(15),
                    onTap: () {},
                  ),
                  QuickAccessTile(
                    label: 'Warehouse',
                    icon: Icons.inventory_2_rounded,
                    iconColor: AppColors.accentMint,
                    backgroundColor: AppColors.accentMint.withAlpha(15),
                    onTap: () => context.push('/app/warehouse'),
                  ),
                  QuickAccessTile(
                    label: 'Production',
                    icon: Icons.precision_manufacturing_rounded,
                    iconColor: AppColors.accentOrange,
                    backgroundColor: AppColors.accentOrange.withAlpha(15),
                    onTap: () => context.push('/app/production'),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 5. All Modules Grid Section Header
              SectionHeader(
                title: 'All Enterprise Modules',
                actionText: 'View All Modules',
                onActionTap: () {},
              ),
              const SizedBox(height: 16),

              // Module Cards List matching Image 2 modern layout with domain-specific images
              _ModuleCard(
                title: 'HR & Employee Management',
                category: 'General & Primary HR',
                location: 'HQ Fenimore St 22A (2.3km)',
                categoryBgColor: const Color(0xFFFFE8D6),
                categoryTextColor: const Color(0xFFC2410C),
                imagePath: 'assets/images/hr_domain.png',
                onTap: () => context.push('/app/leave'),
              ),
              _ModuleCard(
                title: 'IT Helpdesk & Cloud Support',
                category: 'IT & Data Infrastructure',
                location: 'Tech Hub Center (1.5km)',
                categoryBgColor: const Color(0xFFF3E8FF),
                categoryTextColor: const Color(0xFF6B21A8),
                imagePath: 'assets/images/it_domain.png',
                onTap: () => context.push('/app/helpdesk'),
              ),
              _ModuleCard(
                title: 'Warehouse & Inventory Hub',
                category: 'Logistics & Supply Chain',
                location: 'Logistics Bay South (3.1km)',
                categoryBgColor: const Color(0xFFD1FAE5),
                categoryTextColor: const Color(0xFF047857),
                imagePath: 'assets/images/warehouse_domain.png',
                onTap: () => context.push('/app/warehouse'),
              ),
              _ModuleCard(
                title: 'Production & OEE Monitoring',
                category: 'Plant & Manufacturing',
                location: 'Advanced Fabrication (4.2km)',
                categoryBgColor: const Color(0xFFFFEDD5),
                categoryTextColor: const Color(0xFFC2410C),
                imagePath: 'assets/images/production_domain.png',
                onTap: () => context.push('/app/production'),
              ),
              _ModuleCard(
                title: 'EHS Safety & Incident Audit',
                category: 'Safety & Compliance',
                location: 'Plant Safety Office (4.2km)',
                categoryBgColor: const Color(0xFFFEE2E2),
                categoryTextColor: const Color(0xFFB91C1C),
                imagePath: 'assets/images/safety_domain.png',
                onTap: () => context.push('/app/safety'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String title;
  final String category;
  final String location;
  final Color categoryBgColor;
  final Color categoryTextColor;
  final String imagePath;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.title,
    required this.category,
    required this.location,
    required this.categoryBgColor,
    required this.categoryTextColor,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderLight, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C0F172A),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: Row(
            children: [
              // Left Image with Gradient Blend Transition
              SizedBox(
                width: 105,
                height: 108,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    bottomLeft: Radius.circular(28),
                  ),
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.black, Colors.black, Colors.transparent],
                        stops: [0.0, 0.65, 1.0],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: const BoxDecoration(
                            gradient: AppColors.primaryGradient,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Right Info Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Top Pill Category Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: categoryBgColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            color: categoryTextColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Module Title
                      Text(
                        title,
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Sub-location / Metadata Line
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 14,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
