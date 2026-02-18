import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/workout_details_model.dart';
import '../repository/workout_home_repository.dart';

class GetWorkoutDetailUseCase
    extends BaseUseCase<WorkoutDetailResponse, WorkoutDetailParams> {
  final BaseDashboardRepository baseDashboardRepository;

  GetWorkoutDetailUseCase(this.baseDashboardRepository);

  @override
  Future<Either<Failure, WorkoutDetailResponse>> call(
    WorkoutDetailParams parameters,
  ) async {
    return await baseDashboardRepository.getWorkoutDetail(
      workoutId: parameters.workoutId,
    );
  }
}

/// ✅ Parameters class (Clean Architecture standard)
class WorkoutDetailParams extends NoParameters {
  final int workoutId;

  const WorkoutDetailParams({required this.workoutId});
}
