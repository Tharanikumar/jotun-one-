import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class EnterpriseAiOrb extends StatefulWidget {
  final double size;
  final bool isAnimated;
  final String? heroTag;
  final bool isListening;
  final bool isSpeaking;
  final double soundLevel; // 0.0 to 1.0 for mic responsiveness

  const EnterpriseAiOrb({
    super.key,
    this.size = 48.0,
    this.isAnimated = true,
    this.heroTag,
    this.isListening = false,
    this.isSpeaking = false,
    this.soundLevel = 0.0,
  });

  @override
  State<EnterpriseAiOrb> createState() => _EnterpriseAiOrbState();
}

class _EnterpriseAiOrbState extends State<EnterpriseAiOrb>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    if (widget.isAnimated) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(EnterpriseAiOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimated && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.isAnimated && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget orbContent = AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final floatOffset = widget.isAnimated ? math.sin(t * math.pi * 2) * 4.0 : 0.0;
        final pulseScale = widget.isListening
            ? 1.05 + (widget.soundLevel * 0.12) + (math.sin(t * math.pi * 4) * 0.03)
            : widget.isSpeaking
                ? 1.08 + (math.sin(t * math.pi * 6) * 0.05)
                : 1.0 + (math.sin(t * math.pi * 2) * 0.03);

        final rotationAngle = t * math.pi * 2;

        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Transform.scale(
            scale: pulseScale,
            child: SizedBox(
              width: widget.size * 1.25,
              height: widget.size * 1.25,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. Soft Outer Radiant Atmosphere Glow
                  Container(
                    width: widget.size * 1.2,
                    height: widget.size * 1.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accentCyan.withAlpha(widget.isListening ? 110 : 70),
                          AppColors.primary.withAlpha(widget.isSpeaking ? 90 : 50),
                          const Color(0xFF60A5FA).withAlpha(20),
                          Colors.transparent,
                        ],
                        stops: const [0.2, 0.5, 0.8, 1.0],
                      ),
                    ),
                  ),

                  // 2. Glassmorphic Outer Halo Ring
                  Container(
                    width: widget.size * 1.06,
                    height: widget.size * 1.06,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withAlpha(160),
                        width: math.max(1.5, widget.size * 0.02),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withAlpha(widget.isListening ? 90 : 50),
                          blurRadius: widget.size * 0.25,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),

                  // 3. Core Apple/ChatGPT Style Liquid Glass Orb Body
                  Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: const [
                          Colors.white,
                          Color(0xFFE0F2FE), // Soft Ice Cyan
                          Color(0xFF3B82F6), // Vibrant Azure Blue
                          Color(0xFF1D4ED8), // Deep Royal Blue
                        ],
                        stops: const [0.0, 0.35, 0.75, 1.0],
                        begin: Alignment(
                          math.cos(rotationAngle * 0.5),
                          math.sin(rotationAngle * 0.5),
                        ),
                        end: Alignment(
                          -math.cos(rotationAngle * 0.5),
                          -math.sin(rotationAngle * 0.5),
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withAlpha(100),
                          blurRadius: widget.size * 0.3,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Interior Swirling Fluid Core Accent
                        Transform.rotate(
                          angle: rotationAngle * 0.5,
                          child: Container(
                            width: widget.size * 0.8,
                            height: widget.size * 0.8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  Colors.white.withAlpha(180),
                                  const Color(0xFF06B6D4).withAlpha(140),
                                  Colors.transparent,
                                ],
                                stops: const [0.1, 0.6, 1.0],
                                center: const Alignment(-0.3, -0.3),
                              ),
                            ),
                          ),
                        ),

                        // Top Specular Glass Reflection
                        Positioned(
                          top: widget.size * 0.08,
                          left: widget.size * 0.2,
                          child: Container(
                            width: widget.size * 0.45,
                            height: widget.size * 0.22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withAlpha(220),
                                  Colors.white.withAlpha(0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),

                        // Center Minimal Starburst / AI Sparkle Emblem
                        Icon(
                          Icons.auto_awesome_rounded,
                          size: widget.size * 0.42,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),

                  // 4. Floating Tiny Sparkle Node
                  Positioned(
                    top: widget.size * 0.1,
                    right: widget.size * 0.12,
                    child: Icon(
                      Icons.auto_awesome_outlined,
                      size: widget.size * 0.18,
                      color: Colors.white.withAlpha(220),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (widget.heroTag != null) {
      return Hero(
        tag: widget.heroTag!,
        flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: toHeroContext.widget,
                ),
              );
            },
          );
        },
        child: Material(
          color: Colors.transparent,
          child: orbContent,
        ),
      );
    }

    return orbContent;
  }
}
