import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/trip_request.dart';
import '../../domain/repositories/request_repository.dart';
import '../datasources/request_remote_datasource.dart';

/// Implementation of [RequestRepository] using Supabase.
class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDatasource remoteDatasource;
  final SupabaseClient supabaseClient;

  const RequestRepositoryImpl(this.remoteDatasource, this.supabaseClient);

  @override
  Future<List<TripRequest>> getRequestsForTrip(String tripId) async {
    try {
      return await remoteDatasource.getRequestsByTripId(tripId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<TripRequest>> getMyRequests(String passengerId) async {
    try {
      return await remoteDatasource.getMyRequests(passengerId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TripRequest> sendRequest(String tripId, String passengerId) async {
    try {
      return await remoteDatasource.sendRequest(tripId, passengerId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TripRequest> acceptRequest(
      String requestId, String tripId) async {
    try {
      final request =
          await remoteDatasource.updateRequestStatus(requestId, 'accepted');
      final tripResponse = await supabaseClient
          .from('trips')
          .select('available_seats')
          .eq('id', tripId)
          .single();
      final currentSeats = tripResponse['available_seats'] as int;
      await supabaseClient
          .from('trips')
          .update({'available_seats': currentSeats - 1})
          .eq('id', tripId);
      return request;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<TripRequest> rejectRequest(String requestId) async {
    try {
      return await remoteDatasource.updateRequestStatus(requestId, 'rejected');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
