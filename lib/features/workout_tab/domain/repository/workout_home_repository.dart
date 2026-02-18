import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../model/workout_details_model.dart';
import '../model/workout_exercise_details_model.dart';
import '../model/workout_home_model.dart';

abstract class BaseDashboardRepository {
  Future<Either<Failure, DashboardResponse>> getDashboardData();
  Future<Either<Failure, WorkoutDetailResponse>> getWorkoutDetail({
    required int workoutId,
  });
  Future<Either<Failure, WorkoutExerciseDetailsResponse>>
  getWorkoutExerciseDetail({required int exerciseId});
}
