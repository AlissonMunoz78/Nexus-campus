import '../entities/trip_request.dart';

/// Abstract repository for trip request operations.
abstract class RequestRepository {
  /// Returns all requests for a specific trip.
  Future<List<TripRequest>> getRequestsForTrip(String tripId);

  /// Returns all requests made by a specific passenger.
  Future<List<TripRequest>> getMyRequests(String passengerId);

  /// Creates a new request to join a trip.
  Future<TripRequest> sendRequest(String tripId, String passengerId);

  /// Accepts a pending request and decrements available seats.
  Future<TripRequest> acceptRequest(String requestId, String tripId);

  /// Rejects a pending request.
  Future<TripRequest> rejectRequest(String requestId);
}
