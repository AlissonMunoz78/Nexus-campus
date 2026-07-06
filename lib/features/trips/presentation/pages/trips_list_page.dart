import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../providers/trip_provider.dart';

/// Page showing available trips with Coastal Wave card design.
class TripsListPage extends ConsumerWidget {
  const TripsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final role = authState.value?.session?.user.userMetadata?['role'] as String?;
    final isDriver = role == AppStrings.roleDriver;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Viajes disponibles'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        foregroundColor: Colors.white,
        actions: [
          if (isDriver)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => context.push(AppStrings.routeTripsNew),
            ),
        ],
      ),
      body: ref.watch(availableTripsProvider).when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (trips) {
          if (trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.directions_car,
                      size: 64, color: AppColors.primaryLight),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay viajes disponibles',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: trips.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final trip = trips[index];
              final time = DateFormat('hh:mm a').format(trip.departureTime);
              final price = '\$${trip.pricePerSeat.toStringAsFixed(2)}';

              return Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(13, 111, 148, 0.08),
                        blurRadius: 12,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      trip.origin,
                                      style: AppTextStyles.bodyMedium
                                          .copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.arrow_forward,
                                        size: 14, color: AppColors.primaryMid),
                                    const SizedBox(width: 6),
                                    Text(
                                      trip.destination,
                                      style: AppTextStyles.bodyMedium
                                          .copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  time,
                                  style: AppTextStyles.labelSmall,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC0F2EE),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${trip.availableSeats} ${trip.availableSeats == 1 ? 'Asiento' : 'Asientos'}',
                              style: AppTextStyles.labelSmall
                                  .copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Route line with stops
                      SizedBox(
                        height: 72,
                        child: Row(
                          children: [
                            // Vertical line with dots
                            SizedBox(
                              width: 28,
                              child: Column(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            AppColors.primary,
                                            AppColors.primaryMid,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.primaryMid,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Labels
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trip.origin,
                                    style: AppTextStyles.bodyMedium
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const Spacer(),
                                  Text(
                                    trip.destination,
                                    style: AppTextStyles.bodyMedium
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1, color: AppColors.outlineVariant),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Precio total',
                                style: AppTextStyles.labelSmall,
                              ),
                              Text(
                                price,
                                style: AppTextStyles.titleMedium,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.push('/trips/${trip.id}'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24),
                              ),
                              child: Text(
                                'Ver viaje',
                                style: AppTextStyles.labelMedium
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
