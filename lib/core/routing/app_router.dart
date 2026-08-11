import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/ai_assistant/presentation/ai_assistant_screen.dart';
import '../../features/ai_assistant/presentation/voice_ai_assistant_screen.dart';
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

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  errorBuilder: (context, state) => const SplashScreen(),
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/splash',
    ),
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
              builder: (context, state) => const NotificationsScreen(),
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

    // Full Screen Feature Modules
    GoRoute(
      path: '/app/tasks-detail',
      builder: (context, state) => const TasksDetailScreen(),
    ),
    GoRoute(
      path: '/app/approvals-detail',
      builder: (context, state) => const ApprovalsDetailScreen(),
    ),
    GoRoute(
      path: '/app/ai-assistant',
      builder: (context, state) => const AiAssistantScreen(),
    ),
    GoRoute(
      path: '/app/voice-ai-assistant',
      builder: (context, state) => const VoiceAiAssistantScreen(),
    ),
    GoRoute(
      path: '/app/helpdesk',
      builder: (context, state) => const HelpdeskScreen(),
    ),
    GoRoute(
      path: '/app/leave',
      builder: (context, state) => const LeaveScreen(),
    ),
    GoRoute(
      path: '/app/warehouse',
      builder: (context, state) => const WarehouseScreen(),
    ),
    GoRoute(
      path: '/app/production',
      builder: (context, state) => const ProductionScreen(),
    ),
    GoRoute(
      path: '/app/safety',
      builder: (context, state) => const SafetyScreen(),
    ),
  ],
);
