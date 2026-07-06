import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/supabase_client.dart';
import '../../../../core/errors/exceptions.dart' show ServerException;
import '../models/auth_user_model.dart';

/// Datasource remoto que realiza llamadas a Supabase Auth y a la tabla
/// `profiles` para obtener/crear información del usuario.
class AuthRemoteDatasource {
  final SupabaseClient _client = supabaseClient;

  /// Inicia sesión y devuelve el usuario con su perfil si existe.
  Future<AuthUserModel> signIn(String email, String password) async {
    try {
      final res = await _client.auth.signInWithPassword(email: email, password: password);
      final user = res.user;
      if (user == null) throw ServerException('No user returned from auth');

      // Try to fetch profile from `profiles` table
      final profileResp = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle() as Map<String, dynamic>?;

      if (profileResp != null) {
        return AuthUserModel.fromJson(profileResp);
      }

      return AuthUserModel(
        id: user.id,
        email: user.email ?? email,
        role: 'passenger',
      );
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Registra usuario en Supabase Auth y crea fila en `profiles`.
  Future<AuthUserModel> signUp({required String email, required String password, required String role, String? fullName}) async {
    try {
      final res = await _client.auth.signUp(email: email, password: password);
      final user = res.user;
      if (user == null) throw ServerException('Failed to create auth user');

      final profile = {
        'id': user.id,
        'full_name': fullName,
        'email': email,
        'role': role,
        'avatar_url': null,
        'created_at': DateTime.now().toIso8601String(),
      };

      final insert = await _client.from('profiles').insert(profile).select().maybeSingle();
      if (insert == null) {
        // If insert failed, still return a minimal model
        return AuthUserModel(id: user.id, email: email, fullName: fullName, role: role);
      }

      return AuthUserModel.fromJson(Map<String, dynamic>.from(insert as Map));
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Cierra la sesión actual.
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Solicita restablecimiento de contraseña por correo.
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
