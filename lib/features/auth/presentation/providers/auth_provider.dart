import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

/// Datasource provider for auth remote datasource.
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) => AuthRemoteDatasource());

/// Repository provider for auth.
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepositoryImpl(remote: ref.read(authRemoteDatasourceProvider)));

/// StateNotifier that manages authentication actions and exposes AsyncValue<AuthUser?>
class AuthNotifier extends StateNotifier<AsyncValue<AuthUser?>> {
  final Ref ref;

  AuthNotifier(this.ref) : super(const AsyncValue.data(null));

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.signIn(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp(String email, String password, String role, [String? fullName]) async {
    state = const AsyncValue.loading();
    try {
      final user = await _repo.signUp(email: email, password: password, role: role, fullName: fullName);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repo.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    try {
      await _repo.resetPassword(email);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Public provider for authentication state and actions.
final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<AuthUser?>>((ref) {
  return AuthNotifier(ref);
});
