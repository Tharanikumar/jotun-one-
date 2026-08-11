import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/enterprise_ai_orb.dart';

enum VoiceState {
  listening,
  thinking,
  searching,
  generating,
  speaking,
}

extension VoiceStateExtension on VoiceState {
  String get label {
    switch (this) {
      case VoiceState.listening:
        return 'Listening...';
      case VoiceState.thinking:
        return 'Thinking...';
      case VoiceState.searching:
        return 'Searching enterprise database...';
      case VoiceState.generating:
        return 'Generating response...';
      case VoiceState.speaking:
        return 'Speaking...';
    }
  }
}

class VoiceAiAssistantScreen extends StatefulWidget {
  const VoiceAiAssistantScreen({super.key});

  @override
  State<VoiceAiAssistantScreen> createState() => _VoiceAiAssistantScreenState();
}

class _VoiceAiAssistantScreenState extends State<VoiceAiAssistantScreen>
    with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _soundSimController;

  VoiceState _currentState = VoiceState.listening;
  bool _isMuted = false;
  bool _isListening = true;
  double _soundLevel = 0.4;
  Timer? _stateTimer;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _soundSimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _soundSimController.addListener(() {
      if (_isListening && _currentState == VoiceState.listening) {
        setState(() {
          _soundLevel = 0.2 + (_soundSimController.value * 0.6);
        });
      }
    });

    _startStateSimulation();
  }

  void _startStateSimulation() {
    _stateTimer?.cancel();
    _stateTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || !_isListening) return;
      setState(() {
        final nextIndex = (_currentState.index + 1) % VoiceState.values.length;
        _currentState = VoiceState.values[nextIndex];
        if (_currentState == VoiceState.listening) {
          _soundLevel = 0.5;
        } else if (_currentState == VoiceState.thinking || _currentState == VoiceState.searching) {
          _soundLevel = 0.1;
        } else {
          _soundLevel = 0.7;
        }
      });
    });
  }

  @override
  void dispose() {
    _stateTimer?.cancel();
    _rippleController.dispose();
    _soundSimController.dispose();
    super.dispose();
  }

  void _toggleMic() {
    HapticFeedback.lightImpact();
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _currentState = VoiceState.listening;
        _rippleController.repeat();
      } else {
        _rippleController.stop();
        _soundLevel = 0.0;
      }
    });
  }

  void _toggleSpeaker() {
    HapticFeedback.lightImpact();
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF8FAFC), // Crisp Ice White
              Color(0xFFEFF6FF), // Soft Sky Tint
              Color(0xFFDBEAFE), // Light Enterprise Azure
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back / Close Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(200),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(15),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          context.pop();
                        },
                      ),
                    ),

                    // Title Header
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Jotun Voice AI',
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),

                    // Speaker Mute/Unmute Toggle
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(200),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(15),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                          color: _isMuted ? AppColors.error : AppColors.primary,
                        ),
                        onPressed: _toggleSpeaker,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Center Orb Showcase with Animated Multi-Ring Voice Ripples
              Stack(
                alignment: Alignment.center,
                children: [
                  // Custom Ripple Waves Painter
                  AnimatedBuilder(
                    animation: _rippleController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: const Size(320, 320),
                        painter: VoiceRipplePainter(
                          progress: _rippleController.value,
                          isListening: _isListening,
                          soundLevel: _soundLevel,
                          color: AppColors.primary,
                        ),
                      );
                    },
                  ),

                  // Large Enterprise AI Orb Hero Widget
                  EnterpriseAiOrb(
                    size: 210,
                    isAnimated: true,
                    heroTag: 'ai_assistant_orb',
                    isListening: _isListening && _currentState == VoiceState.listening,
                    isSpeaking: _currentState == VoiceState.speaking,
                    soundLevel: _soundLevel,
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Dynamic Assistant State Text with Fade & Scale Animation
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: Tween<double>(begin: 0.92, end: 1.0).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey<VoiceState>(_currentState),
                  child: Column(
                    children: [
                      Text(
                        _isListening ? _currentState.label : 'Voice assistant paused',
                        style: AppTypography.titleLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _isListening
                            ? 'Speak naturally or tap keyboard to type'
                            : 'Tap mic button to resume listening',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Glassmorphism Bottom Control Bar (Material 3 Styling)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(210),
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(20),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Switch to Keyboard / Text Chat Mode Button
                    IconButton.filledTonal(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.background,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.all(14),
                      ),
                      icon: const Icon(Icons.keyboard_rounded, size: 24),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.pop();
                      },
                    ),

                    // Main Microphone Control Button with Glowing Pulse
                    GestureDetector(
                      onTap: _toggleMic,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.primaryGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withAlpha(_isListening ? 120 : 40),
                              blurRadius: _isListening ? 20 : 8,
                              spreadRadius: _isListening ? 4 : 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isListening ? Icons.mic_rounded : Icons.mic_off_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),

                    // Cancel / Close Screen Button
                    IconButton.filledTonal(
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.background,
                        foregroundColor: AppColors.textSecondary,
                        padding: const EdgeInsets.all(14),
                      ),
                      icon: const Icon(Icons.close_rounded, size: 24),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter for Smooth Animated Multi-Ring Voice Ripple Waves
class VoiceRipplePainter extends CustomPainter {
  final double progress;
  final bool isListening;
  final double soundLevel;
  final Color color;

  VoiceRipplePainter({
    required this.progress,
    required this.isListening,
    required this.soundLevel,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isListening) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width * 0.48;

    for (int i = 0; i < 3; i++) {
      final ringProgress = (progress + (i * 0.33)) % 1.0;
      final currentRadius = 75.0 + (ringProgress * (maxRadius - 75.0)) + (soundLevel * 15.0);
      final opacity = (1.0 - ringProgress).clamp(0.0, 1.0) * 0.35;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 + (1.0 - ringProgress) * 2.0
        ..color = color.withAlpha((opacity * 255).toInt());

      canvas.drawCircle(center, currentRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant VoiceRipplePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.isListening != isListening ||
        oldDelegate.soundLevel != soundLevel;
  }
}
