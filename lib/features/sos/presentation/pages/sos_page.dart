import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../providers/emergency_contacts_provider.dart';
import '../providers/sos_provider.dart';
import '../widgets/sos_button.dart';

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
                if (context.mounted) {
                  await _notifyEmergencyContacts(ref, userId, location.latitude, location.longitude);
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

Future<void> _notifyEmergencyContacts(
  WidgetRef ref,
  String userId,
  double latitude,
  double longitude,
) async {
  try {
    final contacts = await ref.read(emergencyContactsRepositoryProvider).getContacts(userId);
    if (contacts.isEmpty) return;

    final mapsLink = 'https://maps.google.com/maps?q=$latitude,$longitude';
    final message = '¡Emergencia! Necesito ayuda. Mi ubicación: $mapsLink';

    for (final contact in contacts) {
      final uri = Uri.parse('sms:${contact.phone}?body=${Uri.encodeFull(message)}');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    }
  } catch (_) {
    // Si falla la notificación, la alerta ya quedó registrada en sos_alerts
  }
}
