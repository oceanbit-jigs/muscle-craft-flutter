import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/workout_exercise_details_model.dart';
import '../repository/workout_home_repository.dart';

class GetWorkoutExerciseDetailUseCase
    extends
        BaseUseCase<
          WorkoutExerciseDetailsResponse,
          WorkoutExerciseDetailParams
        > {
  final BaseDashboardRepository baseDashboardRepository;

  GetWorkoutExerciseDetailUseCase(this.baseDashboardRepository);

  @override
  Future<Either<Failure, WorkoutExerciseDetailsResponse>> call(
    WorkoutExerciseDetailParams parameters,
  ) async {
    return await baseDashboardRepository.getWorkoutExerciseDetail(
      exerciseId: parameters.exerciseId,
    );
  }
}

class WorkoutExerciseDetailParams extends NoParameters {
  final int exerciseId;

  const WorkoutExerciseDetailParams({required this.exerciseId});
}
