import 'package:flutter/material.dart';

enum PenguinType { tasks, approvals, tickets, alerts }

class PenguinAvatar extends StatelessWidget {
  final PenguinType type;
  final double size;

  const PenguinAvatar({
    super.key,
    required this.type,
    this.size = 56.0,
  });

  String get assetPath {
    switch (type) {
      case PenguinType.tasks:
        return 'assets/images/penguin_tasks.png';
      case PenguinType.approvals:
        return 'assets/images/penguin_approvals.png';
      case PenguinType.tickets:
        return 'assets/images/penguin_tickets.png';
      case PenguinType.alerts:
        return 'assets/images/penguin_alerts.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Image.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildVectorFallback();
          },
        ),
      ),
    );
  }

  Widget _buildVectorFallback() {
    Color itemColor;
    IconData itemIcon;
    Color circleBg;

    switch (type) {
      case PenguinType.tasks:
        itemColor = const Color(0xFF1D4ED8);
        itemIcon = Icons.assignment_turned_in_rounded;
        circleBg = const Color(0xFFEFF6FF);
        break;
      case PenguinType.approvals:
        itemColor = const Color(0xFF15803D);
        itemIcon = Icons.verified_user_rounded;
        circleBg = const Color(0xFFECFDF5);
        break;
      case PenguinType.tickets:
        itemColor = const Color(0xFF7E22CE);
        itemIcon = Icons.confirmation_number_rounded;
        circleBg = const Color(0xFFF5F3FF);
        break;
      case PenguinType.alerts:
        itemColor = const Color(0xFFC2410C);
        itemIcon = Icons.notifications_active_rounded;
        circleBg = const Color(0xFFFFF7ED);
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: circleBg,
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Penguin Body & Head Base
          Positioned(
            bottom: 2,
            child: Container(
              width: size * 0.72,
              height: size * 0.72,
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 2. White Face & Belly Pod
          Positioned(
            bottom: 3,
            child: Container(
              width: size * 0.52,
              height: size * 0.55,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.elliptical(22, 26)),
              ),
            ),
          ),
          // 3. Rosy Cheeks
          Positioned(
            top: size * 0.38,
            left: size * 0.20,
            child: Container(
              width: 6,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFF472B6).withAlpha(180),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: size * 0.38,
            right: size * 0.20,
            child: Container(
              width: 6,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFF472B6).withAlpha(180),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 4. Penguin Eyes
          Positioned(
            top: size * 0.28,
            left: size * 0.28,
            child: _buildEye(),
          ),
          Positioned(
            top: size * 0.28,
            right: size * 0.28,
            child: _buildEye(),
          ),
          // 5. Cute Orange Beak
          Positioned(
            top: size * 0.36,
            child: Container(
              width: 8,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFF97316),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          // 6. Holding Item Graphic Badge
          Positioned(
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: itemColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: itemColor.withAlpha(80),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                itemIcon,
                color: Colors.white,
                size: size * 0.28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEye() {
    return Container(
      width: 5,
      height: 5,
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        shape: BoxShape.circle,
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 1.5,
          height: 1.5,
          margin: const EdgeInsets.only(top: 0.8, right: 0.8),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
