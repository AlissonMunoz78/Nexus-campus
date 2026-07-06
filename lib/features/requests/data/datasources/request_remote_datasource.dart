import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/trip_request_model.dart';

/// Remote datasource for trip request operations using Supabase.
class RequestRemoteDatasource {
  final SupabaseClient client;

  const RequestRemoteDatasource(this.client);

  Future<List<TripRequestModel>> getRequestsByTripId(String tripId) async {
    try {
      final response = await client
          .from('trip_requests')
          .select()
          .eq('trip_id', tripId)
          .order('created_at');
      final list = (response as List)
          .map((e) => TripRequestModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return list;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<TripRequestModel> sendRequest(String tripId, String passengerId) async {
    try {
      final response = await client
          .from('trip_requests')
          .insert({
            'trip_id': tripId,
            'passenger_id': passengerId,
            'status': 'pending',
          })
          .select()
          .single();
      return TripRequestModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<TripRequestModel> updateRequestStatus(
      String requestId, String status) async {
    try {
      final response = await client
          .from('trip_requests')
          .update({'status': status})
          .eq('id', requestId)
          .select()
          .single();
      return TripRequestModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<TripRequestModel>> getMyRequests(String passengerId) async {
    try {
      final response = await client
          .from('trip_requests')
          .select()
          .eq('passenger_id', passengerId)
          .order('created_at');
      final list = (response as List)
          .map((e) => TripRequestModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return list;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
