import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/user_location.dart';
import '../../domain/usecases/get_current_location_usecase.dart';
import '../../data/datasources/location_local_datasource.dart';
import '../../data/repositories/location_repository_impl.dart';

/// Provider for the location local datasource.
final locationDatasourceProvider = Provider<LocationLocalDatasource>((ref) {
  return const LocationLocalDatasource();
});

/// Provider for the location repository.
final locationRepositoryProvider = Provider<LocationRepositoryImpl>((ref) {
  return LocationRepositoryImpl(ref.watch(locationDatasourceProvider));
});

/// Provider for [GetCurrentLocationUseCase].
final getCurrentLocationUseCaseProvider =
    Provider<GetCurrentLocationUseCase>((ref) {
  return GetCurrentLocationUseCase(ref.watch(locationRepositoryProvider));
});

/// Fetches the current device location.
final currentLocationProvider = FutureProvider<UserLocation>((ref) {
  final useCase = ref.watch(getCurrentLocationUseCaseProvider);
  return useCase(const NoParams());
});
