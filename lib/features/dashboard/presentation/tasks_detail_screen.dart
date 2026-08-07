import 'package:flutter/material.dart';
import '../../../core/extensions/navigation_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class TasksDetailScreen extends StatefulWidget {
  const TasksDetailScreen({super.key});

  @override
  State<TasksDetailScreen> createState() => _TasksDetailScreenState();
}

class _TasksDetailScreenState extends State<TasksDetailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<int> _counterAnimation;

  final List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Complete Q3 Production Safety Audit',
      'due': 'Due Today • High Priority',
      'category': 'Safety',
      'icon': Icons.security_rounded,
      'color': AppColors.primary,
    },
    {
      'title': 'Review Warehouse Stock Discrepancy Log',
      'due': 'Due Today • Normal',
      'category': 'Warehouse',
      'icon': Icons.inventory_2_rounded,
      'color': AppColors.accentMint,
    },
    {
      'title': 'Approve IT Access Request for Alex M.',
      'due': 'Due Tomorrow • Pending',
      'category': 'IT Helpdesk',
      'icon': Icons.key_rounded,
      'color': AppColors.accentPurple,
    },
    {
      'title': 'Inspect Paint Mixing Line #3 Valve',
      'due': 'Due 10 Aug • Maintenance',
      'category': 'Production',
      'icon': Icons.precision_manufacturing_rounded,
      'color': AppColors.accentOrange,
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

    _counterAnimation = IntTween(begin: 0, end: 12).animate(CurvedAnimation(
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
        title: const Text('Task Details'),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fadeAnimation,
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_rounded, color: Colors.white),
          label: Text('New Task', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
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
                // Shared Hero Icon Container Header
                Center(
                  child: Column(
                    children: [
                      Hero(
                        tag: 'hero_tasks',
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(20),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primaryLight, width: 2),
                            ),
                            child: const Icon(
                              Icons.assignment_turned_in_rounded,
                              color: AppColors.primary,
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
                            '${_counterAnimation.value}',
                            style: AppTypography.displayLarge.copyWith(
                              fontSize: 42,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
                      Text(
                        'Active Assigned Tasks',
                        style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '4 High Priority • 8 Normal',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                Text(
                  'Task List',
                  style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Staggered Animated Task List
                ...List.generate(_tasks.length, (index) {
                  final task = _tasks[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: (task['color'] as Color).withAlpha(20),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              task['icon'] as IconData,
                              color: task['color'] as Color,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task['title'] as String,
                                  style: AppTypography.titleMedium.copyWith(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  task['due'] as String,
                                  style: AppTypography.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
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
