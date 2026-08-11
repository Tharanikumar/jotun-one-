import 'package:flutter/material.dart';
import '../../../core/extensions/navigation_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = 'All';
  Map<String, dynamic>? _selectedAlert;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<int> _counterAnimation;

  final List<Map<String, dynamic>> _alerts = [
    {
      'id': 'ALT-2024-00035',
      'title': 'Leave Approved',
      'subtitle':
          'Your leave application for 20 May – 21 May has been approved by HR.',
      'time': '10m ago',
      'tagText': 'Info',
      'tagTextColor': const Color(0xFF2563EB),
      'tagBgColor': const Color(0xFFDBEAFE),
      'icon': Icons.check_circle_outline_rounded,
      'iconColor': const Color(0xFF2563EB),
      'iconBg': const Color(0xFFDBEAFE),
      'category': 'HR & Leaves',
      'isUrgent': false,
      'date': '24 May 2024, 10:15 AM',
      'source': 'HR Portal System',
      'location': 'Head Office',
      'reportedBy': 'System Auto Notify',
      'summary':
          'Your casual leave request for 2 days has been reviewed and approved by HR Management.',
      'recommendedAction':
          'Ensure your pending tasks are handed over to your replacement before departure.',
      'documentName': 'Leave_Approval_Letter.pdf',
      'documentSize': '85 KB',
    },
    {
      'id': 'ALT-2024-00032',
      'title': 'Low Stock Alert: Paint Solvent B',
      'subtitle':
          'Warehouse stock level dropped below 15% threshold in Bay 4.',
      'time': '45m ago',
      'tagText': 'Urgent',
      'tagTextColor': const Color(0xFFEF4444),
      'tagBgColor': const Color(0xFFFEE2E2),
      'icon': Icons.warning_amber_rounded,
      'iconColor': const Color(0xFFF97316),
      'iconBg': const Color(0xFFFFEDD5),
      'category': 'Inventory',
      'isUrgent': true,
      'date': '22 May 2024, 04:15 PM',
      'source': 'Warehouse Management System',
      'location': 'Bay 4',
      'currentStock': '12% (18 Liters)',
      'threshold': '15% (22 Liters)',
      'reportedBy': 'System Auto Alert',
      'summary':
          'Warehouse stock level for Paint Solvent B has dropped below the 15% threshold in Bay 4.',
      'recommendedAction':
          'Replenish stock for Paint Solvent B in Bay 4 at the earliest to avoid production delays.',
      'documentName': 'Stock_Report_Bay4.pdf',
      'documentSize': '128 KB',
    },
    {
      'id': 'ALT-2024-00029',
      'title': 'IT Ticket Status Updated',
      'subtitle': 'Your ticket #IT-2024-00046 has been updated.',
      'time': '2h ago',
      'tagText': 'Info',
      'tagTextColor': const Color(0xFF2563EB),
      'tagBgColor': const Color(0xFFDBEAFE),
      'icon': Icons.confirmation_number_outlined,
      'iconColor': const Color(0xFF8B5CF6),
      'iconBg': const Color(0xFFF3E8FF),
      'category': 'IT Support',
      'isUrgent': false,
      'date': '22 May 2024, 02:10 PM',
      'source': 'IT Helpdesk System',
      'location': 'Main Campus',
      'reportedBy': 'Rohit Sharma (IT Support)',
      'summary':
          'Status of IT Support Ticket #IT-2024-00046 has been updated to In Progress.',
      'recommendedAction':
          'Check your ticket details view for technician responses or updates.',
      'documentName': 'Ticket_Logs_00046.pdf',
      'documentSize': '94 KB',
    },
    {
      'id': 'ALT-2024-00025',
      'title': 'Class Timetable Changed',
      'subtitle':
          'Timetable for Data Structures class on 23 May has been updated.',
      'time': '3h ago',
      'tagText': 'Info',
      'tagTextColor': const Color(0xFF2563EB),
      'tagBgColor': const Color(0xFFDBEAFE),
      'icon': Icons.calendar_today_outlined,
      'iconColor': const Color(0xFF10B981),
      'iconBg': const Color(0xFFD1FAE5),
      'category': 'Academics',
      'isUrgent': false,
      'date': '22 May 2024, 01:00 PM',
      'source': 'Academic Portal',
      'location': 'Hall 302',
      'reportedBy': 'Academic Coordinator',
      'summary':
          'Data Structures lecture timing has been moved from 10:00 AM to 11:30 AM.',
      'recommendedAction':
          'Please verify your updated schedule in the student portal.',
      'documentName': 'Updated_Timetable_May23.pdf',
      'documentSize': '150 KB',
    },
    {
      'id': 'ALT-2024-00021',
      'title': 'Maintenance Downtime',
      'subtitle':
          'System maintenance scheduled on 25 May from 11:00 PM to 2:00 AM.',
      'time': '1d ago',
      'tagText': 'Info',
      'tagTextColor': const Color(0xFF2563EB),
      'tagBgColor': const Color(0xFFDBEAFE),
      'icon': Icons.campaign_outlined,
      'iconColor': const Color(0xFFF97316),
      'iconBg': const Color(0xFFFFEDD5),
      'category': 'System Ops',
      'isUrgent': false,
      'date': '21 May 2024, 09:00 AM',
      'source': 'Infrastructure Operations',
      'location': 'Server Cluster 1',
      'reportedBy': 'DevOps Team',
      'summary':
          'Scheduled server maintenance and database optimizations will take place over the weekend.',
      'recommendedAction':
          'Save all active sessions and draft entries before 11:00 PM on 25 May.',
      'documentName': 'Maintenance_Schedule.pdf',
      'documentSize': '112 KB',
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _counterAnimation = IntTween(begin: 0, end: 2).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedAlert != null) {
      return _buildAlertDetailsScreen(_selectedAlert!);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.safePop(),
        ),
        title: Text(
          'Alerts Center',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                color: AppColors.textPrimary, size: 26),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Circle & Counter
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEDD5),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFDBA74),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.notifications_rounded,
                            color: Color(0xFFF97316),
                            size: 36,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: _counterAnimation,
                        builder: (context, child) {
                          final val = _counterAnimation.value;
                          final formattedVal = val < 10 ? '0$val' : '$val';
                          return Text(
                            formattedVal,
                            style: AppTypography.displayLarge.copyWith(
                              fontSize: 44,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFF97316),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Unread Urgent Alerts',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Requires immediate attention',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4 Stat Cards Row (Flex Overflow Protected!)
                Row(
                  children: [
                    _buildStatCard(
                      icon: Icons.notifications_rounded,
                      iconColor: const Color(0xFFF97316),
                      bgColor: const Color(0xFFFFEDD5),
                      value: '02',
                      valueColor: const Color(0xFFF97316),
                      label: 'Unread',
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      icon: Icons.warning_amber_rounded,
                      iconColor: const Color(0xFFF97316),
                      bgColor: const Color(0xFFFFEDD5),
                      value: '05',
                      valueColor: AppColors.textPrimary,
                      label: 'Urgent',
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      icon: Icons.info_outline_rounded,
                      iconColor: const Color(0xFF2563EB),
                      bgColor: const Color(0xFFDBEAFE),
                      value: '08',
                      valueColor: AppColors.textPrimary,
                      label: 'Informational',
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      icon: Icons.check_circle_outline_rounded,
                      iconColor: const Color(0xFF10B981),
                      bgColor: const Color(0xFFD1FAE5),
                      value: '12',
                      valueColor: AppColors.textPrimary,
                      label: 'All Alerts',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Filter Pills Row (Horizontally Scrollable)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: ['All', 'Unread', 'Urgent', 'Today'].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedFilter = filter;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFFF97316)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFF97316)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Text(
                              filter,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Section Header: Recent Alerts
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Alerts',
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Mark all as read',
                        style: AppTypography.labelLarge.copyWith(
                          color: const Color(0xFFF97316),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // List of Alert Cards
                ..._alerts
                    .where((item) {
                      if (_selectedFilter == 'Unread') {
                        return item['isUrgent'] == true || item['time'].contains('m ago');
                      }
                      if (_selectedFilter == 'Urgent') {
                        return item['isUrgent'] == true;
                      }
                      if (_selectedFilter == 'Today') {
                        return !item['time'].contains('1d ago');
                      }
                      return true;
                    })
                    .map((alert) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildAlertCard(alert),
                        )),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String value,
    required Color valueColor,
    required String label,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x05000000),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedAlert = alert;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: alert['iconBg'] as Color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    alert['icon'] as IconData,
                    color: alert['iconColor'] as Color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert['title'] as String,
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        alert['subtitle'] as String,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      alert['time'] as String,
                      style: AppTypography.bodySmall.copyWith(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: alert['tagBgColor'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        alert['tagText'] as String,
                        style: TextStyle(
                          color: alert['tagTextColor'] as Color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
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

  // Right Screen: Alert Details View
  Widget _buildAlertDetailsScreen(Map<String, dynamic> alert) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () {
            setState(() {
              _selectedAlert = null;
            });
          },
        ),
        title: Text(
          'Alert Details',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check_rounded,
                        color: Colors.white, size: 18),
                    label: const Text(
                      'Mark as Read',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF97316),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedAlert = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFF97316),
                      side: const BorderSide(color: Color(0xFFF97316)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'View All Alerts',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Top Card
            _buildCardContainer(
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: alert['tagBgColor'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        alert['tagText'] as String,
                        style: TextStyle(
                          color: alert['tagTextColor'] as Color,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: alert['iconBg'] as Color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          alert['icon'] as IconData,
                          color: alert['iconColor'] as Color,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 60.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alert['title'] as String,
                                style: AppTypography.titleMedium.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.access_time_rounded,
                                      size: 13, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Alert ID: ${alert['id']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today_outlined,
                                      size: 13, color: AppColors.textMuted),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${alert['date']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTypography.bodySmall.copyWith(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                      ),
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
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Summary Card
            _buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Summary',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alert['summary'] as String,
                    style: AppTypography.bodyMedium.copyWith(
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Meta Table Card (Protected with Expanded!)
            _buildCardContainer(
              child: Column(
                children: [
                  _buildMetaRow(
                    icon: Icons.grid_view_rounded,
                    label: 'Category',
                    value: alert['category'] as String,
                  ),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildMetaRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Source',
                    value: alert['source'] as String,
                  ),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildMetaRow(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: alert['location'] as String,
                  ),
                  if (alert['currentStock'] != null) ...[
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    _buildMetaRow(
                      icon: Icons.access_time_rounded,
                      label: 'Current Stock',
                      value: alert['currentStock'] as String,
                    ),
                  ],
                  if (alert['threshold'] != null) ...[
                    const Divider(height: 24, color: Color(0xFFF1F5F9)),
                    _buildMetaRow(
                      icon: Icons.access_time_rounded,
                      label: 'Threshold',
                      value: alert['threshold'] as String,
                    ),
                  ],
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildMetaRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Reported By',
                    value: alert['reportedBy'] as String,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recommended Action Card
            _buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommended Action',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alert['recommendedAction'] as String,
                    style: AppTypography.bodyMedium.copyWith(
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.note_add_outlined,
                          color: Color(0xFFF97316), size: 18),
                      label: const Text(
                        'Create Purchase Request',
                        style: TextStyle(
                          color: Color(0xFFF97316),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFF7ED),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFFFEDD5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Activity Timeline Card
            _buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity Timeline',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildTimelineItem(
                    icon: Icons.notifications_rounded,
                    iconColor: const Color(0xFFF97316),
                    iconBg: const Color(0xFFFFEDD5),
                    title: 'Alert Triggered',
                    subtitle: 'Stock level dropped below 15% threshold',
                    time: '22 May 2024, 04:15 PM',
                    isFirst: true,
                  ),
                  _buildTimelineItem(
                    icon: Icons.visibility_outlined,
                    iconColor: const Color(0xFF2563EB),
                    iconBg: const Color(0xFFDBEAFE),
                    title: 'Alert Viewed',
                    subtitle: 'Viewed by Warehouse Incharge',
                    time: '22 May 2024, 04:25 PM',
                  ),
                  _buildTimelineItem(
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: const Color(0xFF10B981),
                    iconBg: const Color(0xFFD1FAE5),
                    title: 'Action Taken',
                    subtitle: 'Purchase request created for replenishment',
                    time: '22 May 2024, 04:35 PM',
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Related Documents Card
            _buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Related Documents (1)',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.picture_as_pdf_rounded,
                              color: Color(0xFFEF4444),
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alert['documentName'] as String,
                                style: AppTypography.titleMedium.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                alert['documentSize'] as String,
                                style: AppTypography.bodySmall.copyWith(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.download_rounded,
                              color: AppColors.textSecondary, size: 22),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildMetaRow({
    required IconData icon,
    required String label,
    String? value,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value ?? '',
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String time,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}

