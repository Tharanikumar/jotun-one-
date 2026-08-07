import 'package:flutter/material.dart';
import '../../../core/extensions/navigation_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class HelpdeskScreen extends StatefulWidget {
  const HelpdeskScreen({super.key});

  @override
  State<HelpdeskScreen> createState() => _HelpdeskScreenState();
}

class _HelpdeskScreenState extends State<HelpdeskScreen> with SingleTickerProviderStateMixin {
  String _selectedFilter = 'All';
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
      'statusColor': AppColors.primary,
    },
    {
      'id': '#IT-2024-00047',
      'title': 'System running slow',
      'date': '22 May 2024 • 04:15 PM',
      'status': 'In Progress',
      'statusColor': AppColors.warning,
    },
    {
      'id': '#IT-2024-00046',
      'title': 'Email not syncing',
      'date': '21 May 2024 • 11:20 AM',
      'status': 'Open',
      'statusColor': AppColors.primary,
    },
    {
      'id': '#IT-2024-00042',
      'title': 'Printer driver installation request',
      'date': '18 May 2024 • 02:45 PM',
      'status': 'Closed',
      'statusColor': AppColors.success,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.safePop(),
        ),
        title: const Text('IT Ticket Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_rounded, color: AppColors.primary, size: 28),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fadeAnimation,
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: AppColors.accentPurple,
          icon: const Icon(Icons.confirmation_number_rounded, color: Colors.white),
          label: Text('Raise Ticket', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shared Hero Icon Showcase
                Center(
                  child: Column(
                    children: [
                      Hero(
                        tag: 'hero_tickets',
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.accentPurple.withAlpha(20),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.accentPurple, width: 2),
                            ),
                            child: const Icon(
                              Icons.confirmation_number_rounded,
                              color: AppColors.accentPurple,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      AnimatedBuilder(
                        animation: _counterAnimation,
                        builder: (context, child) {
                          return Text(
                            '0${_counterAnimation.value}',
                            style: AppTypography.displayLarge.copyWith(
                              fontSize: 42,
                              color: AppColors.accentPurple,
                            ),
                          );
                        },
                      ),
                      Text(
                        'Active IT Support Tickets',
                        style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '2 Open • 1 In Progress',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Filter Pills
                Row(
                  children: ['All', 'Open', 'In Progress', 'Closed'].map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        selectedColor: AppColors.accentPurple,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Tickets List
                Expanded(
                  child: ListView.builder(
                    itemCount: _tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = _tickets[index];
                      if (_selectedFilter != 'All' && ticket['status'] != _selectedFilter) {
                        return const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GlassCard(
                          onTap: () {},
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ticket['id'] as String,
                                    style: AppTypography.labelSmall.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: (ticket['statusColor'] as Color).withAlpha(30),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      ticket['status'] as String,
                                      style: AppTypography.labelSmall.copyWith(
                                        color: ticket['statusColor'] as Color,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ticket['title'] as String,
                                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                ticket['date'] as String,
                                style: AppTypography.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
