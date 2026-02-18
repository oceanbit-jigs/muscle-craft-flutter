import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fitness_workout_app/features/auth/domain/usecase/update_user_profile_usecase.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/utils/api.dart';
import '../../../../core/utils/strings.dart';
import '../../../../dio/api_client.dart';
import '../../../../dio/model/success_model.dart';
import '../../../../local_database/local_storage.dart';
import '../../domain/model/login_model.dart';
import '../../domain/model/logout_model.dart';
import '../../domain/model/register_model.dart';
import '../../domain/model/update_user_profile_model.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/register_usecase.dart';

abstract class BaseRegisterDatasource {
  Future<RegisterResponseModel> registerUser(RegisterUserParameter parameters);
  Future<LoginResponseModel> loginUser(LoginUserParameter parameters);
  Future<LogoutResponse> logoutUser(String token);
  Future<UserResponse> updateUserDetails(UpdateUserProfileParams params);
  Future<SuccessModel> deleteAccount(NoParameters parameters);
}

class RegisterDatasource extends BaseRegisterDatasource {
  @override
  Future<RegisterResponseModel> registerUser(
    RegisterUserParameter parameters,
  ) async {
    try {
      print("Register User API Called");

      final Map<String, dynamic> body = {
        "name": parameters.name,
        "email": parameters.email,
        // "phone": parameters.phone,
        "password": parameters.password,
        "confirm_password": parameters.confirmPassword,
      };

      if (parameters.image != null) {
        body['image_url'] = await MultipartFile.fromFile(
          parameters.image!.path,
          filename: parameters.image!.path.split('/').last,
        );
      }

      final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.register,
        body: body,
      );

      final data = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterResponseModel.fromJson(data);
      } else if (data['error'] != null && data['error'] is List) {
        final errorMessages = (data['error'] as List)
            .map((e) => e['error'].toString())
            .join('\n');
        throw ServerException(message: errorMessages);
      } else if (data['message'] != null) {
        throw ServerException(message: data['message']);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    } catch (e, stack) {
      log("Register User : error  : $e");
      log("Register User : stack  : $stack");

      // For unexpected errors
      if (e is ServerException) {
        throw ServerException(message: e.message);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    }
  }

  @override
  Future<LoginResponseModel> loginUser(LoginUserParameter parameters) async {
    try {
      print("Login User API Called");

      final Map<String, dynamic> body = {
        "email": parameters.email,
        "password": parameters.password,
      };

      final response = await DioClient().postRequest(
        url: Api.baseurl + Api.login,
        body: body,
      );

      final data = response.data;

      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return LoginResponseModel.fromJson(data);
      // } else if (data['error'] != null && data['error'] is List) {
      //   final errorMessages = (data['error'] as List)
      //       .map((e) => e['error'].toString())
      //       .join('\n');
      //   throw ServerException(message: errorMessages);
      // } else if (data['message'] != null) {
      //   throw ServerException(message: data['message']);
      // } else {
      //   //throw ServerException(message: Stringss.serverFailureMessage);
      //   throw ServerException(message: data['message'] ?? 'Login failed');
      // }
      if (response.statusCode == 200 || response.statusCode == 201) {
        return LoginResponseModel.fromJson(data);
      } else {
        if (data['error'] != null) {
          if (data['error'] is List) {
            final errorMessages = (data['error'] as List)
                .map((e) => e['error'].toString())
                .join('\n');
            throw ServerException(message: errorMessages);
          } else if (data['error'] is String) {
            throw ServerException(message: data['error']);
          }
        }

        if (data['message'] != null) {
          throw ServerException(message: data['message']);
        }

        throw ServerException(message: 'Login failed');
      }
    } catch (e, stack) {
      log(
        "Login User : error  : ${e is ServerException ? e.message : e.toString()}",
      );

      log("Login User : stack  : $stack");

      if (e is ServerException) {
        throw ServerException(message: e.message);
      } else {
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    }
  }

  @override
  Future<LogoutResponse> logoutUser(String token) async {
    try {
      final Map<String, dynamic> body = {"token": token};

      final response = await DioClient().postRequest(
        url: Api.baseurl + Api.logout,
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return LogoutResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? Stringss.serverFailureMessage,
        );
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserResponse> updateUserDetails(UpdateUserProfileParams params) async {
    try {
      print("Update User Details API Called");

      final Map<String, dynamic> body = {
        "name": params.name,
        "email": params.email,
        "phone": params.phone,
        "user_id": params.userId,
      };

      if (params.imageUrl != null) {
        if (params.imageUrl!.contains("/")) {
          body['image_url'] = await MultipartFile.fromFile(
            params.imageUrl!,
            filename: params.imageUrl!.split('/').last,
          );
        } else {
          body['image_url'] = params.imageUrl;
        }
      }

      String? token = await LocalStorage.getToken();
      if (token == null) {
        throw ServerException(message: "User not logged in");
      }

      final response = await DioClient().postMultipartRequest(
        url: Api.baseurl + Api.updateUserProfile,
        body: body,
        token: token,
      );

      final data = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserResponse.fromJson(data);
      } else if (data['error'] != null && data['error'] is List) {
        final errorMessages = (data['error'] as List)
            .map((e) => e['error'].toString())
            .join('\n');
        throw ServerException(message: errorMessages);
      } else if (data['message'] != null) {
        throw ServerException(message: data['message']);
      } else {
        throw ServerException(message: "Server error");
      }
    } catch (e, stack) {
      log("Update User Details : error  : $e");
      log("Update User Details : stack  : $stack");

      if (e is ServerException) {
        throw ServerException(message: e.message);
      } else {
        throw ServerException(message: "Server error");
      }
    }
  }

  @override
  Future<SuccessModel> deleteAccount(NoParameters parameters) async {
    Response response;
    final token = await LocalStorage.getToken();
    try {
      response = await DioClient().deleteRequest(
        url: Api.baseurl + Api.softDelete,
        token: token,
      );
      log("Account add response........${response.data}");
      if (response.statusCode == 200) {
        return SuccessModel.fromJson(response.data);
      } else {
        Stringss.serverFailureMessage = response.data['error'] is List
            ? response.data['error'][0]['error']
            : response.data['error'];
        throw ServerException(message: Stringss.serverFailureMessage);
      }
    } catch (e) {
      if (e is DioException) {
        final errorMessage = e.response!.data.toString();
        print("Account add errorMessage ______________${errorMessage}");
        throw ServerException(message: e.response!.data['message']);
      } else if (e is ServerException) {
        throw ServerException(message: e.message);
      }
      throw ServerException(message: Stringss.serverFailureMessage);
    }
  }
}
