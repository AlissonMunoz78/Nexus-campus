import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/trip_model.dart';

/// Remote datasource for trip operations using Supabase.
class TripRemoteDatasource {
  final SupabaseClient client;

  const TripRemoteDatasource(this.client);

  Future<List<TripModel>> getAvailableTrips() async {
    try {
      final response = await client
          .from('trips')
          .select()
          .eq('status', 'active')
          .gt('available_seats', 0)
          .order('departure_time');
      final list = (response as List)
          .map((e) => TripModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return list;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<List<TripModel>> getMyTrips(String driverId) async {
    try {
      final response = await client
          .from('trips')
          .select()
          .eq('driver_id', driverId)
          .order('departure_time');
      final list = (response as List)
          .map((e) => TripModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return list;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<TripModel> createTrip(
      String driverId, String origin, String destination,
      DateTime departureTime, int totalSeats, double pricePerSeat) async {
    try {
      final response = await client
          .from('trips')
          .insert({
            'driver_id': driverId,
            'origin': origin,
            'destination': destination,
            'departure_time': departureTime.toIso8601String(),
            'total_seats': totalSeats,
            'available_seats': totalSeats,
            'price_per_seat': pricePerSeat,
            'status': 'active',
          })
          .select()
          .single();
      return TripModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<TripModel> updateTrip(
      String tripId, Map<String, dynamic> fields) async {
    try {
      final response = await client
          .from('trips')
          .update(fields)
          .eq('id', tripId)
          .select()
          .single();
      return TripModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> deleteTrip(String tripId) async {
    try {
      await client
          .from('trips')
          .update({'status': 'cancelled'})
          .eq('id', tripId);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
