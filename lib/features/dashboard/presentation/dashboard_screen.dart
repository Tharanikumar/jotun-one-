import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/quick_access_tile.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/stat_card.dart';
import '../../../core/widgets/enterprise_ai_orb.dart';
import '../../../core/widgets/penguin_avatar.dart';

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
                  Expanded(
                    child: Row(
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good Morning,',
                                style: AppTypography.bodyMedium,
                              ),
                              Text(
                                'Tharani Kumar 👋',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.titleMedium.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Text(
                                'Production Department',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
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

              // 4 KPI Metric Cards Grid
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'Tasks',
                      value: '12',
                      penguinType: PenguinType.tasks,
                      imagePath: 'assets/images/penguin_tasks.png',
                      iconBgColor: AppColors.primary.withAlpha(20),
                      iconColor: AppColors.primary,
                      onTap: () => context.push('/app/tasks-detail'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: 'Approvals',
                      value: '05',
                      penguinType: PenguinType.approvals,
                      imagePath: 'assets/images/penguin_approvals.png',
                      iconBgColor: AppColors.accentMint.withAlpha(20),
                      iconColor: AppColors.accentMint,
                      onTap: () => context.push('/app/approvals-detail'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: 'Tickets',
                      value: '03',
                      penguinType: PenguinType.tickets,
                      imagePath: 'assets/images/penguin_tickets.png',
                      iconBgColor: AppColors.accentPurple.withAlpha(20),
                      iconColor: AppColors.accentPurple,
                      onTap: () => context.push('/app/helpdesk'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      title: 'Alerts',
                      value: '02',
                      penguinType: PenguinType.alerts,
                      imagePath: 'assets/images/penguin_alerts.png',
                      iconBgColor: AppColors.accentOrange.withAlpha(20),
                      iconColor: AppColors.accentOrange,
                      onTap: () => context.push('/app/notifications'),
                    ),
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
                    const EnterpriseAiOrb(
                      size: 64,
                      isAnimated: true,
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
                    imageAsset: 'assets/images/penguin_helpdesk.png',
                    onTap: () => context.push('/app/helpdesk'),
                  ),
                  QuickAccessTile(
                    label: 'Leave',
                    icon: Icons.event_note_rounded,
                    iconColor: AppColors.accentMint,
                    backgroundColor: AppColors.accentMint.withAlpha(15),
                    imageAsset: 'assets/images/penguin_leave.png',
                    onTap: () => context.push('/app/leave'),
                  ),
                  QuickAccessTile(
                    label: 'Attendance',
                    icon: Icons.access_time_filled_rounded,
                    iconColor: AppColors.accentPurple,
                    backgroundColor: AppColors.accentPurple.withAlpha(15),
                    imageAsset: 'assets/images/penguin_attendance.png',
                    onTap: () {},
                  ),
                  QuickAccessTile(
                    label: 'HR Services',
                    icon: Icons.people_alt_rounded,
                    iconColor: AppColors.accentOrange,
                    backgroundColor: AppColors.accentOrange.withAlpha(15),
                    imageAsset: 'assets/images/penguin_hr.png',
                    onTap: () {},
                  ),
                  QuickAccessTile(
                    label: 'Dashboard',
                    icon: Icons.pie_chart_rounded,
                    iconColor: AppColors.accentCyan,
                    backgroundColor: AppColors.accentCyan.withAlpha(15),
                    imageAsset: 'assets/images/penguin_dashboard.png',
                    onTap: () {},
                  ),
                  QuickAccessTile(
                    label: 'Payslip',
                    icon: Icons.receipt_long_rounded,
                    iconColor: AppColors.primary,
                    backgroundColor: AppColors.primary.withAlpha(15),
                    imageAsset: 'assets/images/penguin_payslip.png',
                    onTap: () {},
                  ),
                  QuickAccessTile(
                    label: 'Warehouse',
                    icon: Icons.inventory_2_rounded,
                    iconColor: AppColors.accentMint,
                    backgroundColor: AppColors.accentMint.withAlpha(15),
                    imageAsset: 'assets/images/penguin_warehouse.png',
                    onTap: () => context.push('/app/warehouse'),
                  ),
                  QuickAccessTile(
                    label: 'Production',
                    icon: Icons.precision_manufacturing_rounded,
                    iconColor: AppColors.accentOrange,
                    backgroundColor: AppColors.accentOrange.withAlpha(15),
                    imageAsset: 'assets/images/penguin_production.png',
                    onTap: () => context.push('/app/production'),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // 5. All Modules Section Header
              SectionHeader(
                title: 'All Enterprise Modules',
                actionText: 'View All Modules',
                onActionTap: () {},
              ),
              const SizedBox(height: 16),

              // Responsive Domain Cards Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 550;
                  if (isWide) {
                    return Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DomainModuleCard(
                                number: '01',
                                title: 'HR & Employee Management',
                                description: 'Manage employee profile, leave requests, attendance logs, and payslips.',
                                buttonText: 'Explore',
                                imagePath: 'assets/images/hr_domain.png',
                                themeColor: const Color(0xFF2563EB),
                                badgeBgColor: const Color(0xFFEFF6FF),
                                onTap: () => context.push('/app/leave'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DomainModuleCard(
                                number: '02',
                                title: 'IT Helpdesk Support',
                                description: 'Raise technical tickets, track network issues, and chat with live support.',
                                buttonText: 'Get Support',
                                imagePath: 'assets/images/it_domain.png',
                                themeColor: const Color(0xFF7C3AED),
                                badgeBgColor: const Color(0xFFF5F3FF),
                                onTap: () => context.push('/app/helpdesk'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DomainModuleCard(
                                number: '03',
                                title: 'Warehouse & Inventory',
                                description: 'Real-time stock summary, barcode inventory scanner, and dispatch logs.',
                                buttonText: 'View Inventory',
                                imagePath: 'assets/images/warehouse_domain.png',
                                themeColor: const Color(0xFF059669),
                                badgeBgColor: const Color(0xFFECFDF5),
                                onTap: () => context.push('/app/warehouse'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: DomainModuleCard(
                                number: '04',
                                title: 'Production & OEE Monitoring',
                                description: 'Overall Equipment Efficiency (85%), hourly production target vs output.',
                                buttonText: 'View Reports',
                                imagePath: 'assets/images/production_domain.png',
                                themeColor: const Color(0xFFEA580C),
                                badgeBgColor: const Color(0xFFFFF7ED),
                                onTap: () => context.push('/app/production'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DomainModuleCard(
                          number: '05',
                          title: 'EHS Safety & Incident Audit',
                          description: 'Report unsafe acts, near misses, equipment hazards, and OSHA compliance.',
                          buttonText: 'Report Issue',
                          imagePath: 'assets/images/safety_domain.png',
                          themeColor: const Color(0xFFE11D48),
                          badgeBgColor: const Color(0xFFFFF1F2),
                          isFullWidth: true,
                          onTap: () => context.push('/app/safety'),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      DomainModuleCard(
                        number: '01',
                        title: 'HR & Employee Management',
                        description: 'Manage employee profile, leave requests, attendance logs, and payslips.',
                        buttonText: 'Explore',
                        imagePath: 'assets/images/hr_domain.png',
                        themeColor: const Color(0xFF2563EB),
                        badgeBgColor: const Color(0xFFEFF6FF),
                        isFullWidth: true,
                        onTap: () => context.push('/app/leave'),
                      ),
                      const SizedBox(height: 14),
                      DomainModuleCard(
                        number: '02',
                        title: 'IT Helpdesk Support',
                        description: 'Raise technical tickets, track network issues, and chat with live support.',
                        buttonText: 'Get Support',
                        imagePath: 'assets/images/it_domain.png',
                        themeColor: const Color(0xFF7C3AED),
                        badgeBgColor: const Color(0xFFF5F3FF),
                        isFullWidth: true,
                        onTap: () => context.push('/app/helpdesk'),
                      ),
                      const SizedBox(height: 14),
                      DomainModuleCard(
                        number: '03',
                        title: 'Warehouse & Inventory',
                        description: 'Real-time stock summary, barcode inventory scanner, and dispatch logs.',
                        buttonText: 'View Inventory',
                        imagePath: 'assets/images/warehouse_domain.png',
                        themeColor: const Color(0xFF059669),
                        badgeBgColor: const Color(0xFFECFDF5),
                        isFullWidth: true,
                        onTap: () => context.push('/app/warehouse'),
                      ),
                      const SizedBox(height: 14),
                      DomainModuleCard(
                        number: '04',
                        title: 'Production & OEE Monitoring',
                        description: 'Overall Equipment Efficiency (85%), hourly production target vs output.',
                        buttonText: 'View Reports',
                        imagePath: 'assets/images/production_domain.png',
                        themeColor: const Color(0xFFEA580C),
                        badgeBgColor: const Color(0xFFFFF7ED),
                        isFullWidth: true,
                        onTap: () => context.push('/app/production'),
                      ),
                      const SizedBox(height: 14),
                      DomainModuleCard(
                        number: '05',
                        title: 'EHS Safety & Incident Audit',
                        description: 'Report unsafe acts, near misses, equipment hazards, and OSHA compliance.',
                        buttonText: 'Report Issue',
                        imagePath: 'assets/images/safety_domain.png',
                        themeColor: const Color(0xFFE11D48),
                        badgeBgColor: const Color(0xFFFFF1F2),
                        isFullWidth: true,
                        onTap: () => context.push('/app/safety'),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class DomainModuleCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final String buttonText;
  final String imagePath;
  final Color themeColor;
  final Color badgeBgColor;
  final VoidCallback onTap;
  final bool isFullWidth;

  const DomainModuleCard({
    super.key,
    required this.number,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.imagePath,
    required this.themeColor,
    required this.badgeBgColor,
    required this.onTap,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withAlpha(10),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Number Badge (e.g. 01, 02, 03, 04, 05)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    number,
                    style: TextStyle(
                      color: themeColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Main Content: 3D Penguin Image + Title & Description
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 3D Penguin Graphic Avatar
                    SizedBox(
                      width: isFullWidth ? 100 : 80,
                      height: isFullWidth ? 100 : 80,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: themeColor.withAlpha(25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.domain_rounded, color: themeColor, size: 36),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Title & Description
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0F172A),
                              height: 1.25,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF64748B),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Bottom Action Row: Pill Button + Circle Arrow Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Primary Action Pill Button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: themeColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: themeColor.withAlpha(76),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            buttonText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ],
                      ),
                    ),

                    // Secondary Circular Arrow Button
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: themeColor.withAlpha(50),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(8),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        color: themeColor,
                        size: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
