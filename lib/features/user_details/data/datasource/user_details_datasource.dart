import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fitness_workout_app/features/user_details/domain/model/update_user_details_model.dart';
import 'package:fitness_workout_app/features/user_details/domain/usecase/update_user_details_usecase.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/api.dart';
import '../../../../core/utils/strings.dart';
import '../../../../dio/api_client.dart';
import '../../../../local_database/onboarding_storage.dart';
import '../../domain/model/add_user_details_model.dart';
import '../../domain/model/list_focus_area_model.dart';
import '../../domain/model/list_goals_model.dart';
import '../../domain/model/user_full_details_model.dart';
import '../../domain/usecase/user_details_usecase.dart';

abstract class BaseMasterGoalDatasource {
  Future<MasterGoalResponse> getMasterGoalList();
  Future<FocusAreaResponse> getFocusAreaList();
  Future<UserDetailResponse> saveUserDetails(SaveUserDetailsParams params);
  Future<UserDetailsResponse> getUserDetails();
  Future<UpdateUserDetailsModel> updateUserDetails(
    UpdateUserDetailsParams params,
  );
}

class MasterGoalDatasourceImpl extends BaseMasterGoalDatasource {
  @override
  Future<MasterGoalResponse> getMasterGoalList() async {
    try {
      print("Get Master Goal API Called");

      final response = await DioClient().getRequest(
        url: "${Api.baseurl}${Api.goal}",
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Get Master Goal Success: ${response.data}");
        return MasterGoalResponse.fromJson(response.data);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    } catch (e, stack) {
      log("Get Master Goal error: $e");
      log("Get Master Goal stacktrace: $stack");

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
  Future<FocusAreaResponse> getFocusAreaList() async {
    try {
      print("Get Focus Area API Called");

      final response = await DioClient().getRequest(
        url: "${Api.baseurl}${Api.focusAreas}",
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Get Focus Area Success: ${response.data}");
        return FocusAreaResponse.fromJson(response.data);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    } catch (e, stack) {
      log("Get Focus Area error: $e");
      log("Get Focus Area stacktrace: $stack");

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
  Future<UserDetailResponse> saveUserDetails(
    SaveUserDetailsParams params,
  ) async {
    try {
      print("Save User Details API Called");

      final body = {
        "user_name": params.userName,
        "gender": params.gender,
        "age": params.age,
        "height": params.height,
        "height_type": params.heightUnit,
        "current_weight": params.currentWeight,
        "current_weight_type": params.currentWeightUnit,
        "target_weight": params.targetWeight,
        "target_weight_type": params.targetWeightUnit,
        "goal_ids": params.goalIds,
        "focus_area_ids": params.focusAreaIds,
        "is_notification_enable": params.isNotificationEnabled,
      };

      final response = await DioClient().postRequest(
        url: "${Api.baseurl}${Api.userDetails}",
        body: body,
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Save User Details Success: ${response.data}");
        return UserDetailResponse.fromJson(response.data);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    } catch (e, stack) {
      log("Save User Details error: $e");
      log("Save User Details stacktrace: $stack");

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
  Future<UserDetailsResponse> getUserDetails() async {
    try {
      print("Get User Details API Called");

      final response = await DioClient().getRequest(
        url: "${Api.baseurl}${Api.getUserDetails}",
      );

      if (response.statusCode == 200 && response.data != null) {
        log("Get User Details Success: ${response.data}");

        final userDetail = response.data['data']?['user_detail'];
        if (userDetail != null && userDetail['gender'] != null) {
          await OnboardingStorage.saveString(
            "gender",
            userDetail['gender'].toString().toLowerCase(),
          );
          print("Saved gender from API: ${userDetail['gender']}");
        }

        return UserDetailsResponse.fromJson(response.data);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    } catch (e, stack) {
      log("Get User Details error: $e");
      log("Get User Details stacktrace: $stack");

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
  Future<UpdateUserDetailsModel> updateUserDetails(
    UpdateUserDetailsParams params,
  ) async {
    try {
      print("Update User Details API Called");

      final body = {
        "user_detail_id": params.userDetailId,
        "user_name": params.userName,
        "gender": params.gender,
        "age": params.age,
        "height": params.height,
        "height_type": params.heightUnit,
        "current_weight": params.currentWeight,
        "current_weight_type": params.currentWeightUnit,
        "target_weight": params.targetWeight,
        "target_weight_type": params.targetWeightUnit,
        "goal_ids": params.goalIds,
        "focus_area_ids": params.focusAreaIds,
      };

      final response = await DioClient().postRequest(
        url: "${Api.baseurl}${Api.updateUserDetails}",
        body: body,
      );

      if (response.statusCode == 200 && response.data != null) {
        print("Update User Details Success: ${response.data}");
        return UpdateUserDetailsModel.fromJson(response.data);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    } catch (e, stack) {
      log("Update User Details error: $e");
      log("Update User Details stacktrace: $stack");

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
