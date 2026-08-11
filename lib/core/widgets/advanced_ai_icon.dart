import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AdvancedAiIcon extends StatefulWidget {
  final double size;
  final bool isAnimated;
  final IconData? iconData;
  final bool useImageAsset;

  const AdvancedAiIcon({
    super.key,
    this.size = 40.0,
    this.isAnimated = true,
    this.iconData,
    this.useImageAsset = true,
  });

  @override
  State<AdvancedAiIcon> createState() => _AdvancedAiIconState();
}

class _AdvancedAiIconState extends State<AdvancedAiIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    if (widget.isAnimated) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = widget.size * 0.52;
    final sparkSize = widget.size * 0.22;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = widget.isAnimated ? _pulseAnimation.value : 1.0;
        final angle = widget.isAnimated ? _rotationAnimation.value * 0.15 : 0.0;

        return SizedBox(
          width: widget.size * 1.15,
          height: widget.size * 1.15,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Ambient Glow Ring
              Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size * 1.1,
                  height: widget.size * 1.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentCyan.withAlpha(90),
                        AppColors.primary.withAlpha(50),
                        AppColors.accentPurple.withAlpha(0),
                      ],
                      stops: const [0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              ),

              // Glass Border Ring
              Container(
                width: widget.size * 1.02,
                height: widget.size * 1.02,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accentCyan.withAlpha(140),
                    width: math.max(1.5, widget.size * 0.025),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(70),
                      blurRadius: widget.size * 0.25,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),

              // Core AI Content (Asset Image or Custom Rendered Shimmer Sphere)
              widget.useImageAsset
                  ? Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x4006B6D4),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(widget.size * 0.3),
                        child: Image.asset(
                          'assets/images/gemini_ai_avatar.png',
                          width: widget.size,
                          height: widget.size,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildFallbackSphere(angle, iconSize);
                          },
                        ),
                      ),
                    )
                  : _buildFallbackSphere(angle, iconSize),

              // Small Sparkle Accent Overlay
              Positioned(
                top: widget.size * 0.08,
                right: widget.size * 0.08,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.accentCyan,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: sparkSize,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFallbackSphere(double angle, double iconSize) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFF2563EB),
              Color(0xFF06B6D4),
              Color(0xFF8B5CF6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Icon(
            widget.iconData ?? Icons.auto_awesome_rounded,
            size: iconSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
