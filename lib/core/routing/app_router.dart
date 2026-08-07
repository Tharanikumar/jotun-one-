import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/ai_assistant/presentation/ai_assistant_screen.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/onboarding_screen.dart';
import '../../features/authentication/presentation/otp_screen.dart';
import '../../features/authentication/presentation/splash_screen.dart';
import '../../features/dashboard/presentation/approvals_detail_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/dashboard/presentation/tasks_detail_screen.dart';
import '../../features/helpdesk/presentation/helpdesk_screen.dart';
import '../../features/leave/presentation/leave_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/production/presentation/production_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/safety/presentation/safety_screen.dart';
import '../../features/warehouse/presentation/warehouse_screen.dart';
import '../../shared/shell/main_navigation_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

CustomTransitionPage _buildFadeSlidePage<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 480),
    reverseTransitionDuration: const Duration(milliseconds: 450),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOutCubic,
        reverseCurve: Curves.easeInOutCubic,
      );

      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/otp',
      builder: (context, state) => const OtpScreen(),
    ),

    // Stateful Navigation Shell with Bottom Navigation Bar
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/app/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/app/dashboard-view',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/app/notifications',
              pageBuilder: (context, state) => _buildFadeSlidePage(
                context: context,
                state: state,
                child: const NotificationsScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/app/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),

    // Overview Card Shared Element Transition Routes
    GoRoute(
      path: '/app/tasks',
      pageBuilder: (context, state) => _buildFadeSlidePage(
        context: context,
        state: state,
        child: const TasksDetailScreen(),
      ),
    ),
    GoRoute(
      path: '/app/approvals',
      pageBuilder: (context, state) => _buildFadeSlidePage(
        context: context,
        state: state,
        child: const ApprovalsDetailScreen(),
      ),
    ),

    // Full Screen Feature Modules
    GoRoute(
      path: '/app/ai-assistant',
      pageBuilder: (context, state) => _buildFadeSlidePage(
        context: context,
        state: state,
        child: const AiAssistantScreen(),
      ),
    ),
    GoRoute(
      path: '/app/helpdesk',
      pageBuilder: (context, state) => _buildFadeSlidePage(
        context: context,
        state: state,
        child: const HelpdeskScreen(),
      ),
    ),
    GoRoute(
      path: '/app/leave',
      pageBuilder: (context, state) => _buildFadeSlidePage(
        context: context,
        state: state,
        child: const LeaveScreen(),
      ),
    ),
    GoRoute(
      path: '/app/warehouse',
      pageBuilder: (context, state) => _buildFadeSlidePage(
        context: context,
        state: state,
        child: const WarehouseScreen(),
      ),
    ),
    GoRoute(
      path: '/app/production',
      pageBuilder: (context, state) => _buildFadeSlidePage(
        context: context,
        state: state,
        child: const ProductionScreen(),
      ),
    ),
    GoRoute(
      path: '/app/safety',
      pageBuilder: (context, state) => _buildFadeSlidePage(
        context: context,
        state: state,
        child: const SafetyScreen(),
      ),
    ),
  ],
);
