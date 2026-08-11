import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_shadows.dart';

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
                    curve: Curves.easeOutCubic,
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
