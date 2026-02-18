import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fitness_workout_app/features/auth/domain/model/update_user_profile_model.dart';
import 'package:fitness_workout_app/features/auth/domain/usecase/update_user_profile_usecase.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/utils/strings.dart';
import '../../../../dio/model/success_model.dart';
import '../../domain/model/login_model.dart';
import '../../domain/model/logout_model.dart';
import '../../domain/model/register_model.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/register_usecase.dart';
import '../datasource/auth_datasource.dart';

class RegisterRepositoryImpl extends BaseRegisterRepository {
  final BaseRegisterDatasource registerDatasource;

  RegisterRepositoryImpl(this.registerDatasource);

  @override
  Future<Either<Failure, RegisterResponseModel>> registerUser(
    RegisterUserParameter parameters,
  ) async {
    try {
      final result = await registerDatasource.registerUser(parameters);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioError catch (e) {
      log("dio error ${e.error}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("catch error: ${e.toString()}");
      return Left(CustomErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoginResponseModel>> loginUser(
    LoginUserParameter parameters,
  ) async {
    try {
      final result = await registerDatasource.loginUser(parameters);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioError catch (e) {
      log("dio error ${e.error}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("catch error: ${e.toString()}");
      return Left(CustomErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LogoutResponse>> logoutUser(String token) async {
    try {
      final result = await registerDatasource.logoutUser(token);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioError catch (e) {
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      return Left(CustomErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserResponse>> updateUserProfile(
    UpdateUserProfileParams parameters,
  ) async {
    try {
      final result = await registerDatasource.updateUserDetails(parameters);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioError catch (e) {
      log("dio error ${e.error}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("catch error: ${e.toString()}");
      return Left(CustomErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SuccessModel>> deleteAccount(
    NoParameters parameters,
  ) async {
    try {
      final result = await registerDatasource.deleteAccount(parameters);
      return Right(result);
    } on ServerException catch (e, stack) {
      print("error message : server exception : ${e.toString()}");
      print("error message : server exception : ${stack}");

      return Left(ServerFailure(e.message));
    } on DioException catch (e, stack) {
      print("error message : dio exception : $e");
      print("error message : dio exception : $stack");

      return Left(ServerFailure(e.message ?? Stringss.serverFailureMessage));
    } catch (e, stack) {
      print("error message : catch exception : $e");
      print("error message : catch exception : $stack");
      return Left(CustomErrorFailure(e.toString()));
    }
  }
}
