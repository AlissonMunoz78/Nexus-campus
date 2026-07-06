import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/supabase_provider.dart';
import '../../domain/entities/trip_request.dart';
import '../../domain/usecases/send_request_usecase.dart';
import '../../domain/usecases/accept_request_usecase.dart';
import '../../domain/usecases/reject_request_usecase.dart';
import '../../data/datasources/request_remote_datasource.dart';
import '../../data/repositories/request_repository_impl.dart';

/// Provider for the request remote datasource.
final requestDatasourceProvider = Provider<RequestRemoteDatasource>((ref) {
  return RequestRemoteDatasource(ref.watch(supabaseClientProvider));
});

/// Provider for the request repository.
final requestRepositoryProvider = Provider<RequestRepositoryImpl>((ref) {
  return RequestRepositoryImpl(
    ref.watch(requestDatasourceProvider),
    ref.watch(supabaseClientProvider),
  );
});

/// Provider for [SendRequestUseCase].
final sendRequestUseCaseProvider = Provider<SendRequestUseCase>((ref) {
  return SendRequestUseCase(ref.watch(requestRepositoryProvider));
});

/// Provider for [AcceptRequestUseCase].
final acceptRequestUseCaseProvider = Provider<AcceptRequestUseCase>((ref) {
  return AcceptRequestUseCase(ref.watch(requestRepositoryProvider));
});

/// Provider for [RejectRequestUseCase].
final rejectRequestUseCaseProvider = Provider<RejectRequestUseCase>((ref) {
  return RejectRequestUseCase(ref.watch(requestRepositoryProvider));
});

/// State notifier that manages trip request actions.
class RequestNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  RequestNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> sendRequest(String tripId, String passengerId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(sendRequestUseCaseProvider)(
        SendRequestParams(tripId: tripId, passengerId: passengerId),
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> acceptRequest(String requestId, String tripId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(acceptRequestUseCaseProvider)(
        AcceptRequestParams(requestId: requestId, tripId: tripId),
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> rejectRequest(String requestId) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(rejectRequestUseCaseProvider)(
        RejectRequestParams(requestId: requestId),
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider for [RequestNotifier] that exposes request send/accept/reject actions.
final requestNotifierProvider =
    StateNotifierProvider<RequestNotifier, AsyncValue<void>>((ref) {
  return RequestNotifier(ref);
});

/// Fetches all requests for a given trip.
final requestsByTripProvider =
    FutureProvider.family<List<TripRequest>, String>((ref, tripId) {
  return ref.read(requestRepositoryProvider).getRequestsForTrip(tripId);
});

/// Fetches all requests made by a given passenger.
final myRequestsProvider =
    FutureProvider.family<List<TripRequest>, String>((ref, passengerId) {
  return ref.read(requestRepositoryProvider).getMyRequests(passengerId);
});
