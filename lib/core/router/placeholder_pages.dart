import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Placeholder for the trips list feature (team: trips team).
class TripsPlaceholderPage extends StatelessWidget {
  const TripsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_car, size: 56, color: AppColors.primaryLight),
            const SizedBox(height: 16),
            const Text('Viajes', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            const Text('En construcción por el equipo', style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for the create trip feature (team: trips team).
class CreateTripPlaceholderPage extends StatelessWidget {
  const CreateTripPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline, size: 56, color: AppColors.primaryLight),
            const SizedBox(height: 16),
            const Text('Crear viaje', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            const Text('En construcción por el equipo', style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for the trip detail feature (team: trips team).
class TripDetailPlaceholderPage extends StatelessWidget {
  final String tripId;

  const TripDetailPlaceholderPage({required this.tripId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 56, color: AppColors.primaryLight),
            const SizedBox(height: 16),
            const Text('Detalle del viaje', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            const Text('En construcción por el equipo', style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for the requests feature (team: requests team).
class RequestsPlaceholderPage extends StatelessWidget {
  const RequestsPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
              ),
              child: const Icon(Icons.swap_horiz, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text('Solicitudes', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            Text(
              'En construcción por el equipo',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for the chat feature (team: chat team).
class ChatPlaceholderPage extends StatelessWidget {
  final String tripId;

  const ChatPlaceholderPage({required this.tripId, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.chat_bubble_outline, size: 56, color: AppColors.primaryLight),
            const SizedBox(height: 16),
            const Text('Chat', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            const Text('En construcción por el equipo', style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for the map feature (team: map team).
class MapPlaceholderPage extends StatelessWidget {
  const MapPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, size: 56, color: AppColors.primaryLight),
            const SizedBox(height: 16),
            const Text('Mapa', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            const Text('En construcción por el equipo', style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Placeholder for the SOS feature (team: sos team).
class SosPlaceholderPage extends StatelessWidget {
  const SosPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.emergency_outlined, size: 56, color: AppColors.primaryLight),
            const SizedBox(height: 16),
            const Text('SOS', style: AppTextStyles.titleMedium),
            const SizedBox(height: 8),
            const Text('En construcción por el equipo', style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}
