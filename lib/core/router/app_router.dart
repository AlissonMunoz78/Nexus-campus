import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_strings.dart';
import '../constants/app_colors.dart';
import '../providers/supabase_provider.dart';

// Real pages
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/vehicles/presentation/pages/vehicle_page.dart';
import '../../features/vehicles/presentation/pages/edit_vehicle_page.dart';
import '../../features/trips/presentation/pages/trips_list_page.dart';
import '../../features/trips/presentation/pages/create_trip_page.dart';
import '../../features/trips/presentation/pages/trip_detail_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/sos/presentation/pages/sos_page.dart';
import 'placeholder_pages.dart';

/// Exposes the application's GoRouter configured with redirect rules based on
/// the Supabase auth state.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppStrings.routeSplash,
    redirect: (context, state) {
      final authState = ref.watch(authStateProvider);
      final isAuthenticated = authState.asData?.value.session != null;
      final onAuthRoute = state.matchedLocation.startsWith('/auth');

      if (!isAuthenticated && !onAuthRoute) return AppStrings.routeLogin;
      if (isAuthenticated && onAuthRoute) return AppStrings.routeHome;
      return null;
    },
    routes: [
      GoRoute(
        path: AppStrings.routeSplash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppStrings.routeLogin,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppStrings.routeRegister,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppStrings.routeForgot,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppStrings.routeHome,
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: AppStrings.routeTrips,
            builder: (context, state) => const TripsListPage(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const CreateTripPage(),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => TripDetailPage(tripId: state.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: AppStrings.routeRequests,
            builder: (context, state) => const RequestsPlaceholderPage(),
          ),
          GoRoute(
            path: '/chat/:tripId',
            builder: (context, state) => ChatPage(tripId: state.pathParameters['tripId']!),
          ),
          GoRoute(
            path: AppStrings.routeMap,
            builder: (context, state) => const MapPage(),
          ),
          GoRoute(
            path: AppStrings.routeProfile,
            builder: (context, state) => const ProfilePage(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const EditProfilePage(),
              ),
            ],
          ),
          GoRoute(
            path: AppStrings.routeVehicle,
            builder: (context, state) => const VehiclePage(),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const EditVehiclePage(),
              ),
            ],
          ),
          GoRoute(
            path: AppStrings.routeSos,
            builder: (context, state) => const SosPage(),
          ),
        ],
      ),
    ],
  );
});

/// Shell widget with bottom navigation bar for the main app sections.
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({required this.child, super.key});

  static const _navRoutes = [
    AppStrings.routeHome,
    AppStrings.routeTrips,
    AppStrings.routeSos,
    AppStrings.routeChat,
    AppStrings.routeProfile,
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _navRoutes.indexWhere((r) => location.startsWith(r));

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, AppColors.background],
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex < 0 ? 0 : currentIndex,
          onTap: (index) => context.go(_navRoutes[index]),
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          backgroundColor: AppColors.surface,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
            BottomNavigationBarItem(icon: Icon(Icons.directions_car_outlined), label: 'Viajes'),
            BottomNavigationBarItem(icon: Icon(Icons.emergency_outlined), label: 'Auxilio'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Mensajes'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
