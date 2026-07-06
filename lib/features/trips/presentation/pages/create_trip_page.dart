import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

import '../../../../core/providers/supabase_provider.dart';
import '../../../../core/widgets/custom_button.dart';
import '../providers/trip_provider.dart';

/// Page for creating a new trip with Coastal Wave form design.
class CreateTripPage extends ConsumerStatefulWidget {
  const CreateTripPage({super.key});

  @override
  ConsumerState<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends ConsumerState<CreateTripPage> {
  final _formKey = GlobalKey<FormState>();
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _commentController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _seats = 3;

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _commentController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null && mounted) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? now,
    );
    if (time != null && mounted) {
      setState(() => _selectedTime = time);
    }
  }

  DateTime? _buildDateTime() {
    if (_selectedDate == null || _selectedTime == null) return null;
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final userId = authState.value?.session?.user.id;
    final notifierState = ref.watch(tripNotifierProvider);

    ref.listen(tripNotifierProvider, (previous, next) {
      if (next is AsyncError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      } else if (next is AsyncData && mounted) {
        context.pop();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Publicar viaje'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WelcomeCard(),
              const SizedBox(height: 16),
              _FormCard(
                icon: Icons.location_on,
                label: 'ORIGEN',
                hint: '¿Desde dónde sales?',
                controller: _originController,
              ),
              const SizedBox(height: 12),
              _FormCard(
                icon: Icons.explore,
                label: 'DESTINO',
                hint: '¿Hacia dónde vas?',
                controller: _destinationController,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DateCard(
                      icon: Icons.calendar_today,
                      label: 'FECHA',
                      value: _selectedDate != null
                          ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
                          : null,
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateCard(
                      icon: Icons.schedule,
                      label: 'HORA',
                      value: _selectedTime != null
                          ? _selectedTime!.format(context)
                          : null,
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _FormCard(
                icon: Icons.payments,
                label: 'PRECIO POR ASIENTO',
                hint: '0.00',
                controller: _priceController,
                prefix: '\$',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 12),
              _SeatsStepper(seats: _seats, onChanged: (v) => setState(() => _seats = v)),
              const SizedBox(height: 12),
              _CommentCard(controller: _commentController),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, AppColors.background],
          ),
        ),
        child: SafeArea(
          top: false,
          child: CustomButton(
            label: 'Publicar viaje',
            isLoading: notifierState.isLoading,
            onPressed: () async {
              if (!_formKey.currentState!.validate()) return;
              final dt = _buildDateTime();
              if (dt == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Selecciona fecha y hora')),
                );
                return;
              }
              if (userId == null) return;
              await ref.read(tripNotifierProvider.notifier).createTrip(
                    userId,
                    _originController.text.trim(),
                    _destinationController.text.trim(),
                    dt,
                    _seats,
                    double.parse(_priceController.text.trim()),
                  );
            },
          ),
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(13, 111, 148, 0.08),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Comparte tu ruta',
              style: AppTextStyles.titleLarge
                  .copyWith(color: AppColors.primary)),
          const SizedBox(height: 4),
          Text(
            'Reduce costos y conoce gente nueva.',
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? prefix;
  final TextInputType? keyboardType;

  const _FormCard({
    required this.icon,
    required this.label,
    required this.hint,
    required this.controller,
    this.prefix,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(13, 111, 148, 0.08),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.labelSmall
                        .copyWith(letterSpacing: 1)),
                const SizedBox(height: 4),
                if (prefix != null)
                  Row(
                    children: [
                      Text(prefix!,
                          style: AppTextStyles.bodyLarge
                              .copyWith(color: AppColors.onBackground)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: TextFormField(
                          controller: controller,
                          keyboardType: keyboardType,
                          decoration: InputDecoration.collapsed(
                            hintText: hint,
                            hintStyle: AppTextStyles.bodyLarge
                                .copyWith(color: AppColors.outline),
                          ),
                          style: AppTextStyles.bodyLarge,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Campo requerido';
                            }
                            final n = double.tryParse(v.trim());
                            if (n == null || n <= 0) {
                              return 'Debe ser mayor a 0';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )
                else
                  TextFormField(
                    controller: controller,
                    decoration: InputDecoration.collapsed(
                      hintText: hint,
                      hintStyle: AppTextStyles.bodyLarge
                          .copyWith(color: AppColors.outline),
                    ),
                    style: AppTextStyles.bodyLarge,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback onTap;

  const _DateCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(13, 111, 148, 0.08),
              blurRadius: 12,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: AppTextStyles.labelSmall
                          .copyWith(letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(
                    value ?? 'Seleccionar',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: value != null
                          ? AppColors.onBackground
                          : AppColors.outline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeatsStepper extends StatelessWidget {
  final int seats;
  final ValueChanged<int> onChanged;

  const _SeatsStepper({required this.seats, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(13, 111, 148, 0.08),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'ASIENTOS DISPONIBLES',
            style: AppTextStyles.labelSmall.copyWith(letterSpacing: 2),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: seats > 1 ? () => onChanged(seats - 1) : null,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: seats > 1
                        ? AppColors.primary
                        : AppColors.outlineVariant,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.remove,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  '$seats',
                  style: AppTextStyles.displayLarge
                      .copyWith(color: AppColors.primary),
                ),
              ),
              GestureDetector(
                onTap: seats < 8 ? () => onChanged(seats + 1) : null,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: seats < 8
                        ? AppColors.primary
                        : AppColors.outlineVariant,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final TextEditingController controller;

  const _CommentCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(13, 111, 148, 0.08),
            blurRadius: 12,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'COMENTARIOS ADICIONALES',
            style: AppTextStyles.labelSmall.copyWith(letterSpacing: 1),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration.collapsed(
              hintText: 'Ej: No se permite fumar, espacio para maletas...',
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.outline),
            ),
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
