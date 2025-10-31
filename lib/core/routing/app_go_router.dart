import 'package:apphoctap/feature/score/presentation/page/score_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:apphoctap/feature/listtask/presentation/page/listtask_admin_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apphoctap/feature/listtask/presentation/page/listtask_list_page.dart';
import '../../feature/auth/presentation/pages/login_page.dart';
import '../../feature/auth/presentation/pages/signup_page.dart';
import '../../feature/home/presentation/pages/home_page.dart';
import '../../feature/home/presentation/pages/admin_home_page.dart';
import '../../feature/course/presentation/page/course_list_page.dart';
import '../../feature/course/presentation/page/course_list_page_user.dart';
import '../presentation/widget/admin_bottom_nav.dart';
import '../presentation/widget/user_bottom_nav.dart';
import 'go_router_refresh_change.dart';
import 'app_routes.dart';

class AppGoRouter {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.login,
    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),

    routes: [
      // ---------------- Đăng nhập / Đăng ký ----------------
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        builder: (context, state) => const SignupPage(),
      ),

      // ---------------- SHELL CHUNG ----------------
      ShellRoute(
        builder: (context, state, child) {
          int currentIndex = _getIndexForLocation(state.matchedLocation);

          return FutureBuilder<String?>(
            future: _getUserRole(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final role = snapshot.data;

              // 🎯 Phân navbar theo role
              if (role == 'Admin') {
                return Scaffold(
                  body: child,
                  bottomNavigationBar:
                      AdminBottomNav(initialIndex: currentIndex),
                );
              } else {
                return Scaffold(
                  body: child,
                  bottomNavigationBar:
                      UserBottomNav(initialIndex: currentIndex),
                );
              }
            },
          );
        },

        // ---------------- Các route con ----------------
        routes: [
          // User
          GoRoute(
            path: AppRoutes.homeuser,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppRoutes.courseuser,
            builder: (context, state) => const CourseListPageUser(),
          ),
          GoRoute(
            path: AppRoutes.listtaskuser,
            builder: (context, state) => const ListtaskListPage(),
          ),
          GoRoute(
            path: AppRoutes.score,
            builder: (context, state) => const ScoreListPage(),
          ),

          // Admin
          GoRoute(
            path: AppRoutes.homeadmin,
            builder: (context, state) => const AdminHomePage(),
          ),
          GoRoute(
            path: AppRoutes.courseadmin,
            builder: (context, state) => const CourseListPage(),
          ),
          GoRoute(
            path: AppRoutes.listtaskadmin,
            builder: (context, state) => const ListtaskAdminListPage(),
          ),
        ],
      ),
    ],

    // ---------------- PHÂN QUYỀN ----------------
    redirect: (context, state) async {
      final user = FirebaseAuth.instance.currentUser;
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString('role');

      final loggingIn = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.signup;

      // ❌ Nếu chưa đăng nhập → ép vào Login
      if (user == null) {
        return loggingIn ? null : AppRoutes.login;
      }

      // ✅ Nếu đã đăng nhập, điều hướng đúng role
      if (user != null && (loggingIn || state.matchedLocation == '/')) {
        if (role == 'Admin') return AppRoutes.homeadmin;
        if (role == 'User') return AppRoutes.homeuser;
      }

      return null; // Giữ nguyên vị trí hiện tại nếu không khớp điều kiện
    },
  );

  // ---------------- Helper ----------------
  static int _getIndexForLocation(String path) {
    if (path.startsWith(AppRoutes.homeadmin)) return 0;
    if (path.startsWith(AppRoutes.courseuser)) return 1;
    if (path.startsWith(AppRoutes.homeuser)) return 0;
    if (path.startsWith(AppRoutes.courseuser)) return 1;
    return 0;
  }

  static Future<String?> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
}
