import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../presentation/providers/auth_provider.dart';

/// Register page with role selection cards and Sky Drift design.
class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _role = AppStrings.rolePassenger;

  // Acepta cualquier dominio de correo con formato válido (algo@algo.algo)
  static final RegExp _emailRegex =
      RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _decoration({
    required IconData prefixIcon,
    required String labelText,
    required String hintText,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.primarySoft,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      prefixIcon: Icon(prefixIcon, color: AppColors.secondary),
      labelText: labelText,
      hintText: hintText,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next is AsyncError) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.error.toString())));
        }
      } else if (next is AsyncData) {
        if (next.value != null && mounted) {
          context.go(AppStrings.routeHome);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.go(AppStrings.routeLogin),
                ),
                const SizedBox(height: 48),
                const Text(
                  'Crear cuenta',
                  style: AppTextStyles.displayLarge,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Regístrate con tu correo',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _fullNameController,
                  decoration: _decoration(
                    prefixIcon: Icons.person_outline,
                    labelText: 'Nombre completo',
                    hintText: 'Ej: Juan Pérez',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Campo requerido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: _decoration(
                    prefixIcon: Icons.email_outlined,
                    labelText: AppStrings.emailLabel,
                    hintText: AppStrings.emailHint,
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Campo requerido';
                    if (!_emailRegex.hasMatch(v.trim())) {
                      return 'Correo inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: _decoration(
                    prefixIcon: Icons.lock_outlined,
                    labelText: AppStrings.passwordLabel,
                    hintText: AppStrings.passwordHint,
                  ),
                  validator: (v) {
                    if (v == null || v.length < 6) return AppStrings.errorPasswordShort;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: _decoration(
                    prefixIcon: Icons.lock_outlined,
                    labelText: 'Confirmar contraseña',
                    hintText: 'Repite la contraseña',
                  ),
                  validator: (v) {
                    if (v != _passwordController.text) return 'Las contraseñas no coinciden';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Selecciona tu rol',
                  style: AppTextStyles.labelMedium,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _role = AppStrings.rolePassenger),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _role == AppStrings.rolePassenger ? AppColors.primary : AppColors.outline,
                              width: 2,
                            ),
                            color: _role == AppStrings.rolePassenger ? AppColors.primarySoft : AppColors.surface,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.person,
                                size: 28,
                                color: _role == AppStrings.rolePassenger ? AppColors.primary : AppColors.secondary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Pasajero',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: _role == AppStrings.rolePassenger ? AppColors.primary : AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _role = AppStrings.roleDriver),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _role == AppStrings.roleDriver ? AppColors.primary : AppColors.outline,
                              width: 2,
                            ),
                            color: _role == AppStrings.roleDriver ? AppColors.primarySoft : AppColors.surface,
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.directions_car,
                                size: 28,
                                color: _role == AppStrings.roleDriver ? AppColors.primary : AppColors.secondary,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Conductor',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: _role == AppStrings.roleDriver ? AppColors.primary : AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                CustomButton(
                  label: AppStrings.register,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    await ref.read(authProvider.notifier).signUp(
                      _emailController.text.trim(),
                      _passwordController.text,
                      _role,
                      _fullNameController.text.trim().isEmpty ? null : _fullNameController.text.trim(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}