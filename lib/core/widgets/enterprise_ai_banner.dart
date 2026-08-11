import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_typography.dart';

/// A modern, glassmorphic Enterprise AI Assistant Banner component
/// matched pixel-perfectly with the premium light theme design.
class EnterpriseAiBanner extends StatefulWidget {
  final VoidCallback? onTap;

  const EnterpriseAiBanner({
    super.key,
    this.onTap,
  });

  @override
  State<EnterpriseAiBanner> createState() => _EnterpriseAiBannerState();
}

class _EnterpriseAiBannerState extends State<EnterpriseAiBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ?? () => context.push('/app/ai-assistant'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0C0F172A),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
            BoxShadow(
              color: Color(0x052563EB),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Soft background glow tint behind robot
            Positioned(
              right: -10,
              top: -10,
              bottom: -10,
              width: 160,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0x182563EB),
                      Color(0x086366F1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Row(
              children: [
                // Left Column: Text & CTA Button
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge: [ ✨ AI ASSISTANT ]
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFE0E7FF), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.auto_awesome,
                                size: 10,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'AI ASSISTANT',
                              style: TextStyle(
                                color: Color(0xFF4F46E5),
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Headline: Enterprise AI Assistant
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Enterprise\n',
                              style: AppTypography.displayMedium.copyWith(
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF0F172A),
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                            ),
                            TextSpan(
                              text: 'AI Assistant',
                              style: AppTypography.displayMedium.copyWith(
                                fontSize: 23,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF2563EB),
                                height: 1.15,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      const Text(
                        'Resolve incidents, search knowledge,\nand automate workflows with AI',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 11.5,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Button: ✨ Ask Now →
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x142563EB),
                              blurRadius: 14,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              size: 16,
                              color: Color(0xFF2563EB),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Ask Now →',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Right Column: 3D Robot Dome Illustration with Orbiting Badges
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: const _EnterpriseAiRobotPod(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 3D Robot Dome Illustration Widget with Orbiting Badges
class _EnterpriseAiRobotPod extends StatelessWidget {
  const _EnterpriseAiRobotPod();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      height: 155,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Glowing Pedestal Base Rings
          Positioned(
            bottom: 6,
            child: Container(
              width: 110,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFF818CF8),
                    Color(0xFFC7D2FE),
                    Colors.transparent,
                  ],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x403B82F6),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            child: Container(
              width: 90,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color: const Color(0xFF818CF8), width: 1.5),
              ),
            ),
          ),

          // 2. Glass Dome Outer Sphere
          Container(
            width: 115,
            height: 115,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x30DBEAFE),
                  Color(0x15EFF6FF),
                  Color(0x40EEF2FF),
                ],
              ),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x153B82F6),
                  blurRadius: 16,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Orbital Glass Line Ring
                Container(
                  width: 105,
                  height: 105,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0x6060A5FA),
                      width: 1,
                    ),
                  ),
                ),

                // 3. Cute 3D White Robot Head
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Antenna Tip
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 2,
                      height: 6,
                      color: const Color(0xFF94A3B8),
                    ),

                    // Head Outer Capsule
                    Container(
                      width: 58,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A0F172A),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Side Ear Pods
                          Positioned(
                            left: -3,
                            child: Container(
                              width: 6,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF818CF8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -3,
                            child: Container(
                              width: 6,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF818CF8),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),

                          // Dark Visor Face Screen
                          Container(
                            width: 44,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Left Eye
                                Container(
                                  width: 9,
                                  height: 9,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF38BDF8),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF38BDF8),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Right Eye
                                Container(
                                  width: 9,
                                  height: 9,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF38BDF8),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF38BDF8),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 4. Orbiting Feature Badges

          // Top-Left: Green Sparkle Badge ❇️
          Positioned(
            top: 12,
            left: 6,
            child: _buildBadge(
              bgColor: const Color(0xFFDCFCE7),
              icon: Icons.auto_awesome,
              iconColor: const Color(0xFF10B981),
            ),
          ),

          // Top-Right: Purple Chat Badge 💬
          Positioned(
            top: 8,
            right: 4,
            child: _buildBadge(
              bgColor: const Color(0xFFF3E8FF),
              icon: Icons.chat_bubble_rounded,
              iconColor: const Color(0xFFA855F7),
            ),
          ),

          // Bottom-Left: Yellow Chart Badge 📊
          Positioned(
            bottom: 24,
            left: 2,
            child: _buildBadge(
              bgColor: const Color(0xFFFEF3C7),
              icon: Icons.bar_chart_rounded,
              iconColor: const Color(0xFFF59E0B),
            ),
          ),

          // Bottom-Right: Blue Document Badge 📄
          Positioned(
            bottom: 24,
            right: 2,
            child: _buildBadge(
              bgColor: const Color(0xFFDBEAFE),
              icon: Icons.description_rounded,
              iconColor: const Color(0xFF3B82F6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required Color bgColor,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: iconColor.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 14,
        color: iconColor,
      ),
    );
  }
}
