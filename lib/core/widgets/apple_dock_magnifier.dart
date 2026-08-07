import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_shadows.dart';

class MacOsDockItem {
  final String id;
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  final int badgeCount;
  final VoidCallback onTap;

  const MacOsDockItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.gradientColors,
    this.badgeCount = 0,
    required this.onTap,
  });
}

class MacOsFloatingDockBar extends StatefulWidget {
  final List<MacOsDockItem> items;
  final int selectedIndex;
  final double maxMagnification;

  const MacOsFloatingDockBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    this.maxMagnification = 0.40,
  });

  @override
  State<MacOsFloatingDockBar> createState() => _MacOsFloatingDockBarState();
}

class _MacOsFloatingDockBarState extends State<MacOsFloatingDockBar>
    with SingleTickerProviderStateMixin {
  double? _hoverIndex;
  late AnimationController _resetController;
  late List<double> _currentScales;
  late List<double> _targetScales;

  @override
  void initState() {
    super.initState();
    _currentScales = List.filled(widget.items.length, 1.0);
    _targetScales = List.filled(widget.items.length, 1.0);

    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addListener(() {
        setState(() {
          for (int i = 0; i < widget.items.length; i++) {
            _currentScales[i] = _currentScales[i] +
                (_targetScales[i] - _currentScales[i]) * _resetController.value;
          }
        });
      });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _updateHover(double localX, double totalWidth) {
    if (totalWidth <= 0 || widget.items.isEmpty) return;
    final count = widget.items.length;
    final itemWidth = totalWidth / count;
    final hoverIdx = (localX / itemWidth).clamp(0.0, count - 1.0);

    setState(() {
      _hoverIndex = hoverIdx;
      for (int i = 0; i < count; i++) {
        final distance = (i - hoverIdx).abs();
        final scaleIncrease = widget.maxMagnification *
            math.exp(-(distance * distance) / (2 * 0.5 * 0.5));
        _currentScales[i] = 1.0 + scaleIncrease;
      }
    });
  }

  void _resetHover() {
    setState(() {
      _hoverIndex = null;
      for (int i = 0; i < widget.items.length; i++) {
        _targetScales[i] = 1.0;
      }
    });
    _resetController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.items.length;
    final activeHoverItemIndex = _hoverIndex?.round();

    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        // macOS Floating Glass Dock Container
        Container(
          margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
          height: 72,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xE61E1B4B), // Translucent Deep Navy Glass
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withAlpha(50),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(120),
                      blurRadius: 30,
                      spreadRadius: 2,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final totalWidth = constraints.maxWidth;

                    return Listener(
                      onPointerDown: (event) {
                        _resetController.stop();
                        _updateHover(event.localPosition.dx, totalWidth);
                      },
                      onPointerMove: (event) {
                        _resetController.stop();
                        _updateHover(event.localPosition.dx, totalWidth);
                      },
                      onPointerUp: (_) => _resetHover(),
                      onPointerCancel: (_) => _resetHover(),
                      child: MouseRegion(
                        onHover: (event) {
                          _resetController.stop();
                          _updateHover(event.localPosition.dx, totalWidth);
                        },
                        onExit: (_) => _resetHover(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: List.generate(count, (index) {
                            final item = widget.items[index];
                            final isSelected = index == widget.selectedIndex;
                            final scale = _currentScales[index];
                            final isMagnified = scale > 1.08;

                            return GestureDetector(
                              onTap: item.onTap,
                              child: AnimatedContainer(
                                duration: _hoverIndex == null
                                    ? const Duration(milliseconds: 200)
                                    : Duration.zero,
                                curve: Curves.easeOutBack,
                                transform: Matrix4.diagonal3Values(scale, scale, 1.0)
                                  ..setTranslationRaw(0.0, isMagnified ? -14.0 : 0.0, 0.0),
                                transformAlignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // macOS Squircle Icon Container
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: item.gradientColors,
                                            ),
                                            borderRadius: BorderRadius.circular(14),
                                            boxShadow: [
                                              BoxShadow(
                                                color: item.gradientColors.first
                                                    .withAlpha(100),
                                                blurRadius: 10,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            item.icon,
                                            color: Colors.white,
                                            size: 26,
                                          ),
                                        ),
                                        // macOS Red Notification Badge Count
                                        if (item.badgeCount > 0)
                                          Positioned(
                                            top: -6,
                                            right: -6,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEF4444),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 1.5,
                                                ),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black38,
                                                    blurRadius: 4,
                                                  ),
                                                ],
                                              ),
                                              constraints: const BoxConstraints(
                                                minWidth: 20,
                                                minHeight: 20,
                                              ),
                                              child: Text(
                                                '${item.badgeCount}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    // macOS Active App Dot Indicator
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? const Color(0xFFA78BFA)
                                            : Colors.transparent,
                                        boxShadow: isSelected
                                            ? const [
                                                BoxShadow(
                                                  color: Color(0xFFA78BFA),
                                                  blurRadius: 6,
                                                  spreadRadius: 1,
                                                )
                                              ]
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),

        // macOS Tooltip Speech Bubble over Hovered Icon
        if (activeHoverItemIndex != null &&
            activeHoverItemIndex >= 0 &&
            activeHoverItemIndex < count)
          Positioned(
            bottom: 104,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xF00F172A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24, width: 0.8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                widget.items[activeHoverItemIndex].label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class AppleDockMagnifierRow extends StatefulWidget {
  final List<Widget> children;
  final double maxMagnification;
  final double neighborMagnification;
  final Duration animationDuration;

  const AppleDockMagnifierRow({
    super.key,
    required this.children,
    this.maxMagnification = 0.22, // Active card scales to 1.22x
    this.neighborMagnification = 0.08, // Neighbor card scales to 1.08x
    this.animationDuration = const Duration(milliseconds: 250),
  });

  @override
  State<AppleDockMagnifierRow> createState() => _AppleDockMagnifierRowState();
}

class _AppleDockMagnifierRowState extends State<AppleDockMagnifierRow>
    with SingleTickerProviderStateMixin {
  double? _hoverFractionalIndex;
  late AnimationController _resetController;
  late List<double> _currentScales;
  late List<double> _targetScales;

  @override
  void initState() {
    super.initState();
    _currentScales = List.filled(widget.children.length, 1.0);
    _targetScales = List.filled(widget.children.length, 1.0);

    _resetController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )..addListener(() {
        setState(() {
          for (int i = 0; i < widget.children.length; i++) {
            _currentScales[i] = _currentScales[i] +
                (_targetScales[i] - _currentScales[i]) * _resetController.value;
          }
        });
      });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _updateMagnification(double localX, double totalWidth) {
    if (totalWidth <= 0 || widget.children.isEmpty) return;

    final count = widget.children.length;
    final itemWidth = totalWidth / count;
    final hoverIndex = (localX / itemWidth).clamp(0.0, count - 1.0);

    setState(() {
      _hoverFractionalIndex = hoverIndex;
      for (int i = 0; i < count; i++) {
        final distance = (i - hoverIndex).abs();
        final scaleIncrease = widget.maxMagnification *
            math.exp(-(distance * distance) / (2 * 0.55 * 0.55));
        _currentScales[i] = 1.0 + scaleIncrease;
      }
    });
  }

  void _resetMagnification() {
    setState(() {
      _hoverFractionalIndex = null;
      for (int i = 0; i < widget.children.length; i++) {
        _targetScales[i] = 1.0;
      }
    });
    _resetController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.children.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        return Listener(
          onPointerDown: (event) {
            _resetController.stop();
            _updateMagnification(event.localPosition.dx, totalWidth);
          },
          onPointerMove: (event) {
            _resetController.stop();
            _updateMagnification(event.localPosition.dx, totalWidth);
          },
          onPointerUp: (_) => _resetMagnification(),
          onPointerCancel: (_) => _resetMagnification(),
          child: MouseRegion(
            onHover: (event) {
              _resetController.stop();
              _updateMagnification(event.localPosition.dx, totalWidth);
            },
            onExit: (_) => _resetMagnification(),
            child: Row(
              children: List.generate(count, (index) {
                final scale = _currentScales[index];
                final isMagnified = scale > 1.05;

                return Expanded(
                  child: AnimatedContainer(
                    duration: _hoverFractionalIndex == null
                        ? widget.animationDuration
                        : Duration.zero,
                    curve: Curves.easeOutBack,
                    transform: Matrix4.diagonal3Values(scale, scale, 1.0)
                      ..setTranslationRaw(0.0, isMagnified ? -6.0 : 0.0, 0.0),
                    transformAlignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      boxShadow: isMagnified ? AppShadows.floatingGlass : null,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: widget.children[index],
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
