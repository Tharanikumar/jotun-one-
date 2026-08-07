import 'package:flutter/material.dart';
import '../../../core/extensions/navigation_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class ApprovalsDetailScreen extends StatefulWidget {
  const ApprovalsDetailScreen({super.key});

  @override
  State<ApprovalsDetailScreen> createState() => _ApprovalsDetailScreenState();
}

class _ApprovalsDetailScreenState extends State<ApprovalsDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<int> _counterAnimation;

  final List<Map<String, dynamic>> _approvals = [
    {
      'title': 'Leave Request - Casual (2 Days)',
      'requester': 'Rahul Verma • Production',
      'date': '24 May 2024',
      'icon': Icons.event_available_rounded,
      'color': AppColors.accentMint,
    },
    {
      'title': 'Overtime Pre-Approval (4 Hours)',
      'requester': 'Sarah Jenkins • Shift B',
      'date': '24 May 2024',
      'icon': Icons.more_time_rounded,
      'color': AppColors.accentOrange,
    },
    {
      'title': 'Safety Equipment Procurement',
      'requester': 'EHS Audit Team',
      'date': '23 May 2024',
      'icon': Icons.shield_rounded,
      'color': AppColors.primary,
    },
    {
      'title': 'Travel Expense Claim (\$420)',
      'requester': 'Alex Morgan • IT Dept',
      'date': '22 May 2024',
      'icon': Icons.receipt_rounded,
      'color': AppColors.accentPurple,
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

    _counterAnimation = IntTween(begin: 0, end: 5).animate(CurvedAnimation(
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
        title: const Text('Approval Center'),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fadeAnimation,
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: AppColors.accentMint,
          icon: const Icon(Icons.done_all_rounded, color: Colors.white),
          label: Text('Approve All', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Shared Hero Icon Container
                Center(
                  child: Column(
                    children: [
                      Hero(
                        tag: 'hero_approvals',
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.accentMint.withAlpha(20),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.accentMint, width: 2),
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              color: AppColors.accentMint,
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
                              color: AppColors.accentMint,
                            ),
                          );
                        },
                      ),
                      Text(
                        'Pending Approvals',
                        style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Action required from management',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                Text(
                  'Approval Requests',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Approval Item Cards
                ...List.generate(_approvals.length, (index) {
                  final approval = _approvals[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: (approval['color'] as Color).withAlpha(20),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  approval['icon'] as IconData,
                                  color: approval['color'] as Color,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      approval['title'] as String,
                                      style: AppTypography.titleMedium.copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      approval['requester'] as String,
                                      style: AppTypography.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.error,
                                  side: const BorderSide(color: AppColors.error),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Reject'),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accentMint,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Approve'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
