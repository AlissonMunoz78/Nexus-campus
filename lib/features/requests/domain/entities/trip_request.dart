import 'package:equatable/equatable.dart';

/// Entity representing a request to join a trip.
class TripRequest extends Equatable {
  final String id;
  final String tripId;
  final String passengerId;
  final String status;
  final DateTime createdAt;

  const TripRequest({
    required this.id,
    required this.tripId,
    required this.passengerId,
    required this.status,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, tripId, passengerId, status, createdAt];
}
