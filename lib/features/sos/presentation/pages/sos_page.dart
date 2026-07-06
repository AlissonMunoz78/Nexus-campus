import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../providers/sos_provider.dart';
import '../widgets/sos_button.dart';

/// SOS emergency page with a long-press-activated alert button.
class SosPage extends ConsumerWidget {
  const SosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final userId = authState.value?.session?.user.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.sosTitle),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SosButton(
              onSosTriggered: () async {
                if (userId == null) return;
                final location =
                    await ref.read(currentLocationProvider.future);
                await ref.read(sosNotifierProvider.notifier).sendSosAlert(
                      userId,
                      location.latitude,
                      location.longitude,
                      '',
                    );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(AppStrings.sosSent)),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.sosHoldToSend.toUpperCase(),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
