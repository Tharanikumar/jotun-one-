import 'package:flutter/material.dart';
import '../../../core/extensions/navigation_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class HelpdeskScreen extends StatefulWidget {
  const HelpdeskScreen({super.key});

  @override
  State<HelpdeskScreen> createState() => _HelpdeskScreenState();
}

class _HelpdeskScreenState extends State<HelpdeskScreen>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = 'All';
  Map<String, dynamic>? _selectedTicket;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<int> _counterAnimation;

  final List<Map<String, dynamic>> _tickets = [
    {
      'id': '#IT-2024-00048',
      'title': 'VPN is not connecting',
      'date': '23 May 2024 • 09:30 AM',
      'status': 'Open',
      'statusColor': const Color(0xFF8B5CF6),
      'statusBg': const Color(0xFFF3E8FF),
      'priority': 'High Priority',
      'priorityColor': const Color(0xFFEF4444),
      'priorityBg': const Color(0xFFFEE2E2),
      'icon': Icons.public_rounded,
      'iconColor': const Color(0xFF8B5CF6),
      'iconBg': const Color(0xFFF3E8FF),
      'category': 'Network',
      'assignedTo': 'Rohit Sharma',
      'assignedRole': 'IT Support Technician',
      'expectedResolution': '24 May 2024, 06:00 PM',
      'location': 'Main Campus',
      'attachmentsCount': '2 Files',
      'description':
          'VPN is not connecting on my laptop since this morning. I have tried multiple times but it shows connection timeout error.',
    },
    {
      'id': '#IT-2024-00047',
      'title': 'System running slow',
      'date': '22 May 2024 • 04:15 PM',
      'status': 'In Progress',
      'statusColor': const Color(0xFFF97316),
      'statusBg': const Color(0xFFFFEDD5),
      'priority': 'Medium Priority',
      'priorityColor': const Color(0xFFF97316),
      'priorityBg': const Color(0xFFFFEDD5),
      'icon': Icons.speed_rounded,
      'iconColor': const Color(0xFFF97316),
      'iconBg': const Color(0xFFFFEDD5),
      'category': 'Hardware',
      'assignedTo': 'Anita Roy',
      'assignedRole': 'System Administrator',
      'expectedResolution': '23 May 2024, 02:00 PM',
      'location': 'Building B, Floor 2',
      'attachmentsCount': '1 File',
      'description':
          'Laptop performance has degraded significantly after recent system update. OS freezes during heavy multitasking.',
    },
    {
      'id': '#IT-2024-00046',
      'title': 'Email not syncing',
      'date': '21 May 2024 • 11:20 AM',
      'status': 'Open',
      'statusColor': const Color(0xFF8B5CF6),
      'statusBg': const Color(0xFFF3E8FF),
      'priority': 'Low Priority',
      'priorityColor': const Color(0xFF2563EB),
      'priorityBg': const Color(0xFFDBEAFE),
      'icon': Icons.mail_outline_rounded,
      'iconColor': const Color(0xFF2563EB),
      'iconBg': const Color(0xFFDBEAFE),
      'category': 'Software',
      'assignedTo': 'Helpdesk Support',
      'assignedRole': 'IT Specialist',
      'expectedResolution': '22 May 2024, 05:00 PM',
      'location': 'Main Campus',
      'attachmentsCount': '0 Files',
      'description':
          'Outlook desktop client is unable to fetch incoming emails. Webmail is functioning normally.',
    },
    {
      'id': '#IT-2024-00045',
      'title': 'Printer not working',
      'date': '20 May 2024 • 10:05 AM',
      'status': 'Resolved',
      'statusColor': const Color(0xFF10B981),
      'statusBg': const Color(0xFFD1FAE5),
      'priority': 'Low Priority',
      'priorityColor': const Color(0xFF2563EB),
      'priorityBg': const Color(0xFFDBEAFE),
      'icon': Icons.print_outlined,
      'iconColor': const Color(0xFF10B981),
      'iconBg': const Color(0xFFD1FAE5),
      'category': 'Hardware',
      'assignedTo': 'Vikas Kumar',
      'assignedRole': 'Field Engineer',
      'expectedResolution': '20 May 2024, 04:00 PM',
      'location': 'Production Floor 1',
      'attachmentsCount': '1 File',
      'description':
          'Label printer #3 is showing paper jam error despite paper tray being cleared.',
    },
    {
      'id': '#IT-2024-00044',
      'title': 'WiFi keeps disconnecting',
      'date': '19 May 2024 • 03:45 PM',
      'status': 'Closed',
      'statusColor': const Color(0xFF64748B),
      'statusBg': const Color(0xFFF1F5F9),
      'priority': 'Medium Priority',
      'priorityColor': const Color(0xFFF97316),
      'priorityBg': const Color(0xFFFFEDD5),
      'icon': Icons.wifi_rounded,
      'iconColor': const Color(0xFF64748B),
      'iconBg': const Color(0xFFF1F5F9),
      'category': 'Network',
      'assignedTo': 'Network Operations',
      'assignedRole': 'Network Engineer',
      'expectedResolution': '20 May 2024, 11:00 AM',
      'location': 'Conference Room A',
      'attachmentsCount': '0 Files',
      'description':
          'Intermittent Wi-Fi signal dropouts observed during video conference meetings.',
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

    _counterAnimation = IntTween(begin: 0, end: 3).animate(CurvedAnimation(
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
    if (_selectedTicket != null) {
      return _buildTicketDetailsScreen(_selectedTicket!);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
          onPressed: () => context.safePop(),
        ),
        title: Text(
          'IT Ticket Management',
          style: AppTypography.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.add, color: Colors.white, size: 22),
              onPressed: () {},
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.confirmation_number_outlined,
                  color: Colors.white, size: 20),
              label: Text(
                'Raise Ticket',
                style: AppTypography.titleMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ),
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
                // Header Circle & Active Count
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3E8FF),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFDDD6FE),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.confirmation_number_outlined,
                            color: Color(0xFF8B5CF6),
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
                              color: const Color(0xFF8B5CF6),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Active IT Support Tickets',
                        style: AppTypography.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '2 Open • 1 In Progress',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4 Stat Summary Cards Row (Flex Overflow Protected!)
                Row(
                  children: [
                    _buildStatCard(
                      icon: Icons.confirmation_number_outlined,
                      iconColor: const Color(0xFF8B5CF6),
                      bgColor: const Color(0xFFF3E8FF),
                      value: '03',
                      valueColor: const Color(0xFF8B5CF6),
                      label: 'Open',
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      icon: Icons.autorenew_rounded,
                      iconColor: const Color(0xFFF97316),
                      bgColor: const Color(0xFFFFEDD5),
                      value: '01',
                      valueColor: AppColors.textPrimary,
                      label: 'In Progress',
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      icon: Icons.assignment_turned_in_outlined,
                      iconColor: const Color(0xFF10B981),
                      bgColor: const Color(0xFFD1FAE5),
                      value: '08',
                      valueColor: AppColors.textPrimary,
                      label: 'Resolved',
                    ),
                    const SizedBox(width: 8),
                    _buildStatCard(
                      icon: Icons.work_outline_rounded,
                      iconColor: const Color(0xFF64748B),
                      bgColor: const Color(0xFFF1F5F9),
                      value: '12',
                      valueColor: AppColors.textPrimary,
                      label: 'Closed',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Filter Pills Row (Horizontally Scrollable)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: ['All', 'Open', 'In Progress', 'Closed'].map((filter) {
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
                                  ? const Color(0xFF8B5CF6)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF8B5CF6)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Row(
                              children: [
                                if (isSelected) ...[
                                  const Icon(Icons.check,
                                      size: 14, color: Colors.white),
                                  const SizedBox(width: 6),
                                ],
                                Text(
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
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // List of Tickets
                ..._tickets
                    .where((t) =>
                        _selectedFilter == 'All' || t['status'] == _selectedFilter)
                    .map((ticket) => Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: _buildTicketCard(ticket),
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

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
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
              _selectedTicket = ticket;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: ticket['iconBg'] as Color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    ticket['icon'] as IconData,
                    color: ticket['iconColor'] as Color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ticket['id'] as String,
                            style: AppTypography.labelSmall.copyWith(
                              color: const Color(0xFF2563EB),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: ticket['statusBg'] as Color,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              ticket['status'] as String,
                              style: TextStyle(
                                color: ticket['statusColor'] as Color,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ticket['title'] as String,
                        style: AppTypography.titleMedium.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ticket['date'] as String,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: ticket['priorityBg'] as Color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          ticket['priority'] as String,
                          style: TextStyle(
                            color: ticket['priorityColor'] as Color,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Right Screen: Ticket Details View
  Widget _buildTicketDetailsScreen(Map<String, dynamic> ticket) {
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
              _selectedTicket = null;
            });
          },
        ),
        title: Text(
          'Ticket Details',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Hero Card
            _buildCardContainer(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: ticket['iconBg'] as Color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      ticket['icon'] as IconData,
                      color: ticket['iconColor'] as Color,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              ticket['id'] as String,
                              style: AppTypography.labelSmall.copyWith(
                                color: const Color(0xFF2563EB),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: ticket['statusBg'] as Color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                ticket['status'] as String,
                                style: TextStyle(
                                  color: ticket['statusColor'] as Color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          ticket['title'] as String,
                          style: AppTypography.titleMedium.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: ticket['priorityBg'] as Color,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                ticket['priority'] as String,
                                style: TextStyle(
                                  color: ticket['priorityColor'] as Color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '•  ${ticket['category']}',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Created on ${ticket['date']}',
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Meta Details Table
            _buildCardContainer(
              child: Column(
                children: [
                  _buildMetaRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Assigned To',
                    value: ticket['assignedTo'] as String,
                    subValue: ticket['assignedRole'] as String,
                  ),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildMetaRow(
                    icon: Icons.grid_view_rounded,
                    label: 'Category',
                    value: ticket['category'] as String,
                  ),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildMetaRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Expected Resolution',
                    value: ticket['expectedResolution'] as String,
                  ),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildMetaRow(
                    icon: Icons.location_on_outlined,
                    label: 'Location',
                    value: ticket['location'] as String,
                  ),
                  const Divider(height: 24, color: Color(0xFFF1F5F9)),
                  _buildMetaRow(
                    icon: Icons.attach_file_rounded,
                    label: 'Attachments',
                    valueWidget: Text(
                      '${ticket['attachmentsCount']} >',
                      style: AppTypography.bodyMedium.copyWith(
                        color: const Color(0xFF8B5CF6),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Issue Description
            _buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Issue Description',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ticket['description'] as String,
                    style: AppTypography.bodyMedium.copyWith(
                      height: 1.4,
                      color: AppColors.textSecondary,
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
                    icon: Icons.confirmation_number_outlined,
                    iconColor: const Color(0xFF8B5CF6),
                    iconBg: const Color(0xFFF3E8FF),
                    title: 'Ticket Created',
                    subtitle: '23 May 2024, 09:30 AM',
                    author: 'by You',
                    isFirst: true,
                  ),
                  _buildTimelineItem(
                    icon: Icons.person_outline_rounded,
                    iconColor: const Color(0xFF2563EB),
                    iconBg: const Color(0xFFDBEAFE),
                    title: 'Assigned to IT Support',
                    subtitle: '23 May 2024, 10:15 AM',
                    author: 'by System',
                  ),
                  _buildTimelineItem(
                    icon: Icons.build_outlined,
                    iconColor: const Color(0xFFF97316),
                    iconBg: const Color(0xFFFFEDD5),
                    title: 'Technician Responded',
                    subtitle: '23 May 2024, 11:00 AM',
                    author: 'by Rohit Sharma',
                    quoteBox: 'We are checking the VPN server. Will update soon.',
                  ),
                  _buildTimelineItem(
                    icon: Icons.inbox_outlined,
                    iconColor: const Color(0xFF94A3B8),
                    iconBg: const Color(0xFFF1F5F9),
                    title: 'Resolution Pending',
                    subtitle: 'Waiting for technician update',
                  ),
                  _buildTimelineItem(
                    icon: Icons.inbox_outlined,
                    iconColor: const Color(0xFF94A3B8),
                    iconBg: const Color(0xFFF1F5F9),
                    title: 'Closed',
                    subtitle: 'Waiting for your confirmation',
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Conversation Card
            _buildCardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conversation',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildCommentTile(
                    avatarText: 'RS',
                    avatarBg: const Color(0xFF2563EB),
                    name: 'Rohit Sharma',
                    role: '(IT Support)',
                    time: '23 May 2024, 11:00 AM',
                    message: 'We are checking the VPN server. Will update soon.',
                  ),
                  const SizedBox(height: 12),
                  _buildCommentTile(
                    avatarIcon: Icons.person_outline_rounded,
                    avatarBg: const Color(0xFF8B5CF6),
                    name: 'You',
                    role: '',
                    time: '23 May 2024, 11:05 AM',
                    message: 'Sure, please do the needful.',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_file_rounded,
                            color: AppColors.textMuted, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              hintStyle: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textMuted,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send_rounded,
                              color: Color(0xFF8B5CF6), size: 20),
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
    String? subValue,
    Widget? valueWidget,
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
          child: Align(
            alignment: Alignment.centerRight,
            child: valueWidget ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value ?? '',
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (subValue != null)
                      Text(
                        subValue,
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
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
    String? author,
    String? quoteBox,
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
                height: quoteBox != null ? 70 : 36,
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
              RichText(
                text: TextSpan(
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                  children: [
                    TextSpan(text: subtitle),
                    if (author != null)
                      TextSpan(
                        text: ' $author',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                  ],
                ),
              ),
              if (quoteBox != null) ...[
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    quoteBox,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentTile({
    String? avatarText,
    IconData? avatarIcon,
    required Color avatarBg,
    required String name,
    required String role,
    required String time,
    required String message,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: avatarBg,
                child: avatarText != null
                    ? Text(
                        avatarText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Icon(avatarIcon, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: AppTypography.titleMedium.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (role.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  role,
                  style: AppTypography.bodySmall.copyWith(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
              const Spacer(),
              Text(
                time,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            message,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

