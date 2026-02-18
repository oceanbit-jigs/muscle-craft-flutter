import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/api.dart';
import '../../../../core/utils/strings.dart';
import '../../../../dio/api_client.dart';
import '../../domain/model/exercise_model.dart';
import '../../domain/model/show_category_model.dart';

abstract class BaseExerciseDatasource {
  Future<ExerciseResponseModel> getExercises({int page, int? focusAreaId});
  Future<CategoryModel> getCategoryDetails({required int categoryId});
}

class ExerciseDatasourceImpl extends BaseExerciseDatasource {
  @override
  Future<ExerciseResponseModel> getExercises({
    int page = 1,
    int? focusAreaId,
  }) async {
    try {
      print("Get Exercise API Called | Page: $page");

      String url = "${Api.baseurl}${Api.exercise}?page=$page";

      if (focusAreaId != null) {
        url += "&focus_area_id=$focusAreaId";
      }

      // final response = await DioClient().getRequest(
      //   url: "${Api.baseurl}${Api.exercise}?page=$page",
      // );

      final response = await DioClient().getRequest(url: url);

      if (response.statusCode == 200 && response.data != null) {
        print("Get Exercise Success: ${response.data}");
        return ExerciseResponseModel.fromJson(response.data);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    } catch (e, stack) {
      log("Get Exercise error: $e");
      log("Get Exercise stacktrace: $stack");

      if (e is DioException && e.response?.data != null) {
        final errorMessage = e.response!.data.toString();
        log("Get Exercise Dio error: $errorMessage");

        // throw ServerException(
        //   message: e.response!.data['message'] ?? Stringss.serverFailureMessage,
        // );

        final data = e.response?.data;

        throw ServerException(
          message: data is Map && data['message'] != null
              ? data['message']
              : "No data found",
        );
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    }
  }

  @override
  Future<CategoryModel> getCategoryDetails({required int categoryId}) async {
    try {
      print("Get Category Details API Called | ID: $categoryId");

      String url = "${Api.baseurl}${Api.showWorkout}/$categoryId";

      final response = await DioClient().getRequest(url: url);

      if (response.statusCode == 200 && response.data != null) {
        print("Get Category Details Success: ${response.data}");
        return CategoryModel.fromJson(response.data);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    } catch (e, stack) {
      log("Get Category Details error: $e");
      log("Get Category Details stacktrace: $stack");

      if (e is DioException && e.response?.data != null) {
        final data = e.response?.data;

        throw ServerException(
          message: data is Map && data['message'] != null
              ? data['message']
              : "No data found",
        );
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    }
  }
}
