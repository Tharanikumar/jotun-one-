import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import 'penguin_avatar.dart';

/// A 3D Flip & Reveal Stat Card widget that implements the 4-step animation sequence:
/// 1. Tap: Scale down feedback on touch down
/// 2. Flip: 3D perspective rotation around the Y-axis
/// 3. Content Reveal: Swaps front card content with mini-breakdown stats on back card at 90 degrees
/// 4. Navigate / Modal: Expands into detailed Overview modal dialog or navigates to route
class FlipRevealStatCard extends StatefulWidget {
  final String title;
  final String value;
  final String? imagePath;
  final PenguinType? penguinType;
  final Color iconBgColor;
  final Color iconColor;
  final String? badgeCount;
  final String? heroTag;

  // Breakdown statistics for the revealed (back) side
  final int completedCount;
  final int pendingCount;
  final String completedLabel;
  final String pendingLabel;
  final String route;

  const FlipRevealStatCard({
    super.key,
    required this.title,
    required this.value,
    this.imagePath,
    this.penguinType,
    required this.iconBgColor,
    required this.iconColor,
    this.badgeCount,
    this.heroTag,
    this.completedCount = 8,
    this.pendingCount = 4,
    this.completedLabel = 'Completed',
    this.pendingLabel = 'Pending',
    required this.route,
  });

  @override
  State<FlipRevealStatCard> createState() => _FlipRevealStatCardState();
}

class _FlipRevealStatCardState extends State<FlipRevealStatCard>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  bool _isFlipped = false;

  @override
  void initState() {
    super.initState();

    // 3D Flip Controller (500ms smooth cubic flip)
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: math.pi).animate(
      CurvedAnimation(
        parent: _flipController,
        curve: Curves.easeInOutCubic,
      ),
    );

    // Tap scale press feedback controller
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });
    // Direct navigation to feature detail page
    context.push(widget.route);
  }

  void _triggerFlip() {
    if (_isFlipped) {
      _flipController.reverse();
      setState(() {
        _isFlipped = false;
      });
    } else {
      _flipController.forward();
      setState(() {
        _isFlipped = true;
      });
    }
  }

  void _openDetailModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (modalContext) => FlipRevealDetailModal(
        title: widget.title,
        totalValue: widget.value,
        completedCount: widget.completedCount,
        pendingCount: widget.pendingCount,
        completedLabel: widget.completedLabel,
        pendingLabel: widget.pendingLabel,
        accentColor: widget.iconColor,
        route: widget.route,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      onLongPress: _triggerFlip,
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) => _scaleController.reverse(),
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final angle = _flipAnimation.value;
                final isBackVisible = angle >= math.pi / 2;

                // 3D Perspective Matrix transformation
                final transform = Matrix4.identity()
                  ..setEntry(3, 2, 0.0016) // Perspective depth
                  ..rotateY(angle);

                if (isBackVisible) {
                  // Un-mirror text on the back side
                  transform.rotateY(math.pi);
                }

                return Transform(
                  transform: transform,
                  alignment: Alignment.center,
                  child: isBackVisible
                      ? _buildBackCard(context)
                      : _buildFrontCard(context),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // --- 1 & 2. FRONT SIDE OF CARD ---
  PenguinType _getPenguinType() {
    if (widget.penguinType != null) return widget.penguinType!;
    final lower = widget.title.toLowerCase();
    if (lower.contains('task')) return PenguinType.tasks;
    if (lower.contains('approval')) return PenguinType.approvals;
    if (lower.contains('ticket')) return PenguinType.tickets;
    if (lower.contains('alert')) return PenguinType.alerts;
    return PenguinType.tasks;
  }

  Widget _buildFrontCard(BuildContext context) {
    Widget avatarWidget;
    final resolvedType = _getPenguinType();
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
                type: resolvedType,
                size: 58,
              );
            },
          ),
        ),
      );
    } else {
      avatarWidget = PenguinAvatar(
        type: resolvedType,
        size: 64,
      );
    }

    Widget avatarPod = Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        avatarWidget,
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

    return Container(
      key: const ValueKey('front_card'),
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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -4,
            right: -2,
            child: GestureDetector(
              onTap: _triggerFlip,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: widget.iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.sync_rounded,
                  size: 13,
                  color: widget.iconColor.withAlpha(180),
                ),
              ),
            ),
          ),
          Column(
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
    ],
  ),
);
  }

  // --- 3. REVEALED BACK SIDE OF CARD ---
  Widget _buildBackCard(BuildContext context) {
    final total = widget.completedCount + widget.pendingCount;
    final progress = total > 0 ? (widget.completedCount / total) : 0.0;

    return Container(
      key: const ValueKey('back_card'),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: widget.iconColor.withAlpha(80), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: widget.iconColor.withAlpha(25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header title & flip icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.iconColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _flipController.reverse();
                  setState(() => _isFlipped = false);
                },
                child: Icon(
                  Icons.sync_rounded,
                  size: 16,
                  color: widget.iconColor.withAlpha(180),
                ),
              ),
            ],
          ),

          // Big revealed counter (e.g. "03" or "08")
          Column(
            children: [
              Text(
                widget.value,
                style: TextStyle(
                  color: widget.iconColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                ),
              ),
              Text(
                'Total ${widget.title}',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          // Progress bar
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5,
                  backgroundColor: widget.iconColor.withAlpha(30),
                  color: widget.iconColor,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.completedCount} ${widget.completedLabel}',
                    style: TextStyle(
                      color: widget.iconColor,
                      fontSize: 8.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.pendingCount} ${widget.pendingLabel}',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Action Buttons: View Feature Directly & Modal Overview
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 26,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(widget.route);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.iconColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Go to ${widget.title} →',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => _openDetailModal(context),
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: widget.iconColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: widget.iconColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// --- 4. STEP 4: EXPANDED DETAIL OVERVIEW MODAL DIALOG ---
/// Matches Step 4 ("Tasks Overview") from the specification image.
class FlipRevealDetailModal extends StatelessWidget {
  final String title;
  final String totalValue;
  final int completedCount;
  final int pendingCount;
  final String completedLabel;
  final String pendingLabel;
  final Color accentColor;
  final String route;

  const FlipRevealDetailModal({
    super.key,
    required this.title,
    required this.totalValue,
    required this.completedCount,
    required this.pendingCount,
    required this.completedLabel,
    required this.pendingLabel,
    required this.accentColor,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    final total = completedCount + pendingCount;
    final progress = total > 0 ? (completedCount / total) : 0.0;

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 24,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Close Button Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  Text(
                    '$title Overview',
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Total Big Number
              Text(
                totalValue,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Total $title',
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: accentColor.withAlpha(30),
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 10),

              // Stat Breakdown Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$completedCount $completedLabel',
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '$pendingCount $pendingLabel',
                    style: const TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Navigate Button
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push(route);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'View All $title',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
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
