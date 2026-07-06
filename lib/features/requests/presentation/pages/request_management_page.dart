import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../providers/request_provider.dart';

/// Page where the driver can view and manage incoming requests for their trip.
class RequestManagementPage extends ConsumerWidget {
  final String tripId;

  const RequestManagementPage({required this.tripId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestsAsync = ref.watch(requestsByTripProvider(tripId));

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.requestsTitle),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        foregroundColor: Colors.white,
      ),
      body: requestsAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (requests) {
          if (requests.isEmpty) {
            return const Center(child: Text(AppStrings.noRequests));
          }

          final pending =
              requests.where((r) => r.status == 'pending').toList();

          if (pending.isEmpty) {
            return const Center(child: Text(AppStrings.noPendingRequests));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pending.length,
            itemBuilder: (context, index) {
              final request = pending[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(13, 111, 148, 0.08),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                          gradient: AppColors.primaryGradient,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: AppColors.primarySoft,
                                child: Text(
                                  request.passengerId.isNotEmpty
                                      ? request.passengerId[0].toUpperCase()
                                      : '?',
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${AppStrings.passengerLabel}: ${request.passengerId}',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.warning
                                            .withValues(alpha: 0.1),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        request.status,
                                        style: AppTextStyles.bodySmall
                                            .copyWith(
                                          color: AppColors.warning,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              CustomButton(
                                label: AppStrings.accept,
                                onPressed: () async {
                                  await ref
                                      .read(requestNotifierProvider.notifier)
                                      .acceptRequest(request.id, tripId);
                                  if (context.mounted) {
                                    ref.invalidate(
                                        requestsByTripProvider(tripId));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            AppStrings.requestAccepted),
                                      ),
                                    );
                                  }
                                },
                              ),
                              const SizedBox(width: 8),
                              CustomButton(
                                label: AppStrings.reject,
                                isOutlined: true,
                                onPressed: () async {
                                  await ref
                                      .read(requestNotifierProvider.notifier)
                                      .rejectRequest(request.id);
                                  if (context.mounted) {
                                    ref.invalidate(
                                        requestsByTripProvider(tripId));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            AppStrings.requestRejected),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
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
