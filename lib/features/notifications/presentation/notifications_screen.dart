import 'package:flutter/material.dart';
import '../../../core/extensions/navigation_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<int> _counterAnimation;

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.safePop(),
        ),
        title: const Text('Alerts Center'),
      ),
      floatingActionButton: ScaleTransition(
        scale: _fadeAnimation,
        child: FloatingActionButton.extended(
          onPressed: () {},
          backgroundColor: AppColors.accentOrange,
          icon: const Icon(Icons.cleaning_services_rounded, color: Colors.white),
          label: Text('Clear All', style: AppTypography.labelLarge.copyWith(color: Colors.white)),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Hero Icon Header
              Center(
                child: Column(
                  children: [
                    Hero(
                      tag: 'hero_alerts',
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.accentOrange.withAlpha(20),
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.accentOrange, width: 2),
                          ),
                          child: const Icon(
                            Icons.notifications_active_rounded,
                            color: AppColors.accentOrange,
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
                            color: AppColors.accentOrange,
                          ),
                        );
                      },
                    ),
                    Text(
                      'Unread Urgent Alerts',
                      style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Requires immediate attention',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              GlassCard(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0x202563EB),
                    child: Icon(Icons.check_circle_rounded, color: AppColors.primary),
                  ),
                  title: Text('Leave Approved', style: AppTypography.titleMedium),
                  subtitle: Text('Your leave application for 20 May - 21 May has been approved by HR.', style: AppTypography.bodySmall),
                  trailing: Text('10m ago', style: AppTypography.labelSmall),
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0x20F97316),
                    child: Icon(Icons.warning_amber_rounded, color: AppColors.accentOrange),
                  ),
                  title: Text('Low Stock Alert: Paint Solvent B', style: AppTypography.titleMedium),
                  subtitle: Text('Warehouse stock level dropped below 15% threshold in Bay 4.', style: AppTypography.bodySmall),
                  trailing: Text('45m ago', style: AppTypography.labelSmall),
                ),
              ),
              const SizedBox(height: 12),
              GlassCard(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0x20F59E0B),
                    child: Icon(Icons.support_agent_rounded, color: AppColors.warning),
                  ),
                  title: Text('IT Ticket Status Updated', style: AppTypography.titleMedium),
                  subtitle: Text('Ticket #IT-2024-00047 status updated to "In Progress".', style: AppTypography.bodySmall),
                  trailing: Text('2h ago', style: AppTypography.labelSmall),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
