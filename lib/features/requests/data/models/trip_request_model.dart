import '../../domain/entities/trip_request.dart';

/// Data model for [TripRequest] with JSON serialization using Supabase snake_case keys.
class TripRequestModel extends TripRequest {
  const TripRequestModel({
    required String id,
    required String tripId,
    required String passengerId,
    required String status,
    required DateTime createdAt,
  }) : super(
          id: id,
          tripId: tripId,
          passengerId: passengerId,
          status: status,
          createdAt: createdAt,
        );

  factory TripRequestModel.fromJson(Map<String, dynamic> json) {
    return TripRequestModel(
      id: json['id'] as String,
      tripId: json['trip_id'] as String,
      passengerId: json['passenger_id'] as String,
      status: json['status'] as String? ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'trip_id': tripId,
      'passenger_id': passengerId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
