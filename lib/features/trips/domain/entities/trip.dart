import 'package:equatable/equatable.dart';

/// Entity representing a trip published by a driver.
class Trip extends Equatable {
  final String id;
  final String driverId;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final int totalSeats;
  final int availableSeats;
  final double pricePerSeat;
  final String status;

  const Trip({
    required this.id,
    required this.driverId,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.totalSeats,
    required this.availableSeats,
    required this.pricePerSeat,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id, driverId, origin, destination, departureTime,
        totalSeats, availableSeats, pricePerSeat, status,
      ];
}
