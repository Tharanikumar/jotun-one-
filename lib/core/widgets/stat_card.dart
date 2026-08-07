import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'penguin_avatar.dart';

class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData? icon;
  final String? imagePath;
  final PenguinType? penguinType;
  final Color iconBgColor;
  final Color iconColor;
  final String? badgeCount;
  final String? trend;
  final bool isPositive;
  final VoidCallback? onTap;
  final String? heroTag;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
    this.imagePath,
    this.penguinType,
    required this.iconBgColor,
    required this.iconColor,
    this.badgeCount,
    this.trend,
    this.isPositive = true,
    this.onTap,
    this.heroTag,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _iconBounceAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOutCubic),
    );

    _iconBounceAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    if (widget.onTap != null) {
      widget.onTap!();
    }
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget;
    if (widget.imagePath != null) {
      avatarWidget = Container(
        width: 64,
        height: 64,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: widget.iconBgColor,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.asset(
            widget.imagePath!,
            width: 58,
            height: 58,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return PenguinAvatar(
                type: widget.penguinType ?? PenguinType.tasks,
                size: 58,
              );
            },
          ),
        ),
      );
    } else {
      avatarWidget = PenguinAvatar(
        type: widget.penguinType ?? PenguinType.tickets,
        size: 64,
      );
    }

    Widget avatarPod = Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        ScaleTransition(
          scale: _iconBounceAnimation,
          child: avatarWidget,
        ),
        if (widget.badgeCount != null)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                widget.badgeCount!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );

    if (widget.heroTag != null) {
      avatarPod = Hero(
        tag: widget.heroTag!,
        child: Material(
          color: Colors.transparent,
          child: avatarPod,
        ),
      );
    }

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderLight, width: 1),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0C0F172A),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              avatarPod,
              const SizedBox(height: 12),
              Text(
                widget.value,
                style: TextStyle(
                  color: widget.iconColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Color(0xFF1E293B),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Container(
                width: 24,
                height: 3,
                decoration: BoxDecoration(
                  color: widget.iconColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
