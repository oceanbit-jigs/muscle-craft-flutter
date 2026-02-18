import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/strings.dart';
import '../../domain/model/workout_details_model.dart';
import '../../domain/model/workout_exercise_details_model.dart';
import '../../domain/model/workout_home_model.dart';
import '../../domain/repository/workout_home_repository.dart';
import '../datasource/workout_home_datasource.dart';

class DashboardRepositoryImpl extends BaseDashboardRepository {
  final BaseDashboardDatasource dashboardDatasource;

  DashboardRepositoryImpl(this.dashboardDatasource);

  DashboardResponse? _cachedDashboard;
  WorkoutDetailResponse? _cachedWorkoutDetail;
  WorkoutExerciseDetailsResponse? _cachedExerciseDetail;

  DashboardResponse? get dashboard => _cachedDashboard;
  WorkoutDetailResponse? get workoutDetail => _cachedWorkoutDetail;
  WorkoutExerciseDetailsResponse? get exerciseDetail => _cachedExerciseDetail;

  set dashboard(DashboardResponse? data) {
    _cachedDashboard = data;
  }

  set workoutDetail(WorkoutDetailResponse? data) {
    _cachedWorkoutDetail = data;
  }

  set exerciseDetail(WorkoutExerciseDetailsResponse? data) {
    _cachedExerciseDetail = data;
  }

  void clearDashboardRepo() {
    _cachedDashboard = null;
  }

  void clearWorkoutDetailRepo() {
    _cachedWorkoutDetail = null;
  }

  void clearExerciseDetailRepo() {
    _cachedExerciseDetail = null;
  }

  @override
  Future<Either<Failure, DashboardResponse>> getDashboardData() async {
    try {
      final result = await dashboardDatasource.getDashboardData();
      dashboard = result;
      return Right(result);
    } on DioError catch (e) {
      log("Dio error in getDashboardData: ${e.message}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("getDashboardData catch error: ${e.toString()}");
      return Left(CustomErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkoutDetailResponse>> getWorkoutDetail({
    required int workoutId,
  }) async {
    try {
      final result = await dashboardDatasource.getWorkoutDetail(
        workoutId: workoutId,
      );

      workoutDetail = result;
      return Right(result);
    } on DioError catch (e) {
      log("Dio error in getWorkoutDetail: ${e.message}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("getWorkoutDetail catch error: ${e.toString()}");
      return Left(CustomErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkoutExerciseDetailsResponse>>
  getWorkoutExerciseDetail({required int exerciseId}) async {
    try {
      final result = await dashboardDatasource.getWorkoutExerciseDetail(
        exerciseId: exerciseId,
      );
      exerciseDetail = result;
      return Right(result);
    } on DioError catch (e) {
      log("Dio error in getWorkoutExerciseDetail: ${e.message}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("getWorkoutExerciseDetail catch error: ${e.toString()}");
      return Left(CustomErrorFailure(e.toString()));
    }
  }
}
