import 'package:equatable/equatable.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/trip_request.dart';
import '../repositories/request_repository.dart';

/// Parameters for [SendRequestUseCase].
class SendRequestParams extends Equatable {
  final String tripId;
  final String passengerId;

  const SendRequestParams({required this.tripId, required this.passengerId});

  @override
  List<Object?> get props => [tripId, passengerId];
}

/// Use case for sending a trip join request.
class SendRequestUseCase implements UseCase<TripRequest, SendRequestParams> {
  final RequestRepository repository;

  const SendRequestUseCase(this.repository);

  @override
  Future<TripRequest> call(SendRequestParams params) {
    return repository.sendRequest(params.tripId, params.passengerId);
  }
}
