import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/apple_dock_magnifier.dart';

class MainNavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationShell({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: MacOsFloatingDockBar(
        selectedIndex: navigationShell.currentIndex,
        items: [
          MacOsDockItem(
            id: 'home',
            label: 'Home',
            icon: Icons.explore_rounded,
            gradientColors: const [Color(0xFF2563EB), Color(0xFF3B82F6)], // Safari Blue
            onTap: () => _onTap(0),
          ),
          MacOsDockItem(
            id: 'dashboard',
            label: 'Dashboard',
            icon: Icons.dashboard_rounded,
            gradientColors: const [Color(0xFF0284C7), Color(0xFF38BDF8)], // Mail Blue
            onTap: () => _onTap(1),
          ),
          MacOsDockItem(
            id: 'ai_assistant',
            label: 'Jotun AI Assistant',
            icon: Icons.auto_awesome_rounded,
            gradientColors: const [Color(0xFF7C3AED), Color(0xFFA855F7)], // AI Purple
            onTap: () => context.push('/app/ai-assistant'),
          ),
          MacOsDockItem(
            id: 'notifications',
            label: 'Notifications',
            icon: Icons.forum_rounded,
            gradientColors: const [Color(0xFF10B981), Color(0xFF34D399)], // Messages Green
            badgeCount: 162,
            onTap: () => _onTap(2),
          ),
          MacOsDockItem(
            id: 'profile',
            label: 'Profile',
            icon: Icons.person_rounded,
            gradientColors: const [Color(0xFFEC4899), Color(0xFFF472B6)], // Reminders Pink
            onTap: () => _onTap(3),
          ),
        ],
      ),
    );
  }
}
