import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/api.dart';
import '../../../../core/utils/strings.dart';
import '../../../../dio/api_client.dart';
import '../../domain/model/workout_details_model.dart';
import '../../domain/model/workout_exercise_details_model.dart';
import '../../domain/model/workout_home_model.dart';

abstract class BaseDashboardDatasource {
  Future<DashboardResponse> getDashboardData();
  Future<WorkoutDetailResponse> getWorkoutDetail({required int workoutId});
  Future<WorkoutExerciseDetailsResponse> getWorkoutExerciseDetail({
    required int exerciseId,
  });
}

class DashboardDatasourceImpl extends BaseDashboardDatasource {
  @override
  Future<DashboardResponse> getDashboardData() async {
    try {
      print("Get Dashboard API Called");

      final response = await DioClient().getRequest(
        url: "${Api.baseurl}${Api.dashboard}",
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Get Dashboard Success: ${response.data}");
        return DashboardResponse.fromJson(response.data);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    } catch (e, stack) {
      log("Get Dashboard error: $e");
      log("Get Dashboard stacktrace: $stack");

      if (e is DioException && e.response?.data != null) {
        final errorMessage = e.response!.data.toString();
        log("Get Dashboard Dio error: $errorMessage");
        throw ServerException(
          message: e.response!.data['message'] ?? Stringss.serverFailureMessage,
        );
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    }
  }

  @override
  Future<WorkoutDetailResponse> getWorkoutDetail({
    required int workoutId,
  }) async {
    try {
      print("Get Workout Detail API Called");

      final response = await DioClient().getRequest(
        url: "${Api.baseurl}${Api.workoutDetail}/$workoutId",
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Get Workout Detail Success: ${response.data}");
        debugPrint("RAW EXERCISE RESPONSE: ${response.data}");
        return WorkoutDetailResponse.fromJson(response.data);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    } catch (e, stack) {
      log("Get Workout Detail error: $e");
      log("Get Workout Detail stacktrace: $stack");

      if (e is DioException && e.response?.data != null) {
        throw ServerException(
          message: e.response!.data['message'] ?? Stringss.serverFailureMessage,
        );
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    }
  }

  @override
  Future<WorkoutExerciseDetailsResponse> getWorkoutExerciseDetail({
    required int exerciseId,
  }) async {
    try {
      print("Get Workout Exercise Detail API Called");

      final response = await DioClient().getRequest(
        url: "${Api.baseurl}${Api.workoutExerciseDetail}/$exerciseId",
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Get Workout Exercise Detail Success: ${response.data}");
        return WorkoutExerciseDetailsResponse.fromJson(response.data);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    } catch (e, stack) {
      log("Get Workout Exercise Detail error: $e");
      log("Get Workout Exercise Detail stacktrace: $stack");

      if (e is DioException && e.response?.data != null) {
        throw ServerException(
          message: e.response!.data['message'] ?? Stringss.serverFailureMessage,
        );
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    }
  }
}
