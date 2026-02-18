import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/strings.dart';
import '../../domain/model/add_user_details_model.dart';
import '../../domain/model/list_focus_area_model.dart';
import '../../domain/model/list_goals_model.dart';
import '../../domain/model/update_user_details_model.dart';
import '../../domain/model/user_full_details_model.dart';
import '../../domain/repository/user_details_repository.dart';
import '../../domain/usecase/update_user_details_usecase.dart';
import '../../domain/usecase/user_details_usecase.dart';
import '../datasource/user_details_datasource.dart';

class MasterGoalRepositoryImpl extends BaseMasterGoalRepository {
  final BaseMasterGoalDatasource masterGoalDatasource;

  MasterGoalRepositoryImpl(this.masterGoalDatasource);

  MasterGoalResponse? _cachedMasterGoal;
  FocusAreaResponse? _cachedFocusArea;

  MasterGoalResponse? get masterGoal => _cachedMasterGoal;
  FocusAreaResponse? get focusArea => _cachedFocusArea;

  set masterGoal(MasterGoalResponse? data) => _cachedMasterGoal = data;
  set focusArea(FocusAreaResponse? data) => _cachedFocusArea = data;

  void clearMasterGoalRepo() => _cachedMasterGoal = null;
  void clearFocusAreaRepo() => _cachedFocusArea = null;

  @override
  Future<Either<Failure, MasterGoalResponse>> getMasterGoals() async {
    try {
      final result = await masterGoalDatasource.getMasterGoalList();
      masterGoal = result;
      return Right(result);
    } on DioError catch (e) {
      log("Dio error in getMasterGoals: ${e.message}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("getMasterGoals catch error: ${e.toString()}");
      return Left(CustomErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FocusAreaResponse>> getFocusAreas() async {
    try {
      final result = await masterGoalDatasource.getFocusAreaList();
      focusArea = result;
      return Right(result);
    } on DioError catch (e) {
      log("Dio error in getFocusAreas: ${e.message}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("getFocusAreas catch error: ${e.toString()}");
      return Left(CustomErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetailResponse>> saveUserDetails(
    SaveUserDetailsParams params,
  ) async {
    try {
      final result = await masterGoalDatasource.saveUserDetails(params);
      return Right(result);
    } on DioError catch (e) {
      log("Dio error in saveUserDetails: ${e.message}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("saveUserDetails catch error: ${e.toString()}");
      return Left(CustomErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetailsResponse>> getUserDetails() async {
    try {
      final result = await masterGoalDatasource.getUserDetails();
      return Right(result);
    } on DioError catch (e) {
      log("Dio error in getUserDetails: ${e.message}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("getUserDetails catch error: ${e.toString()}");
      return Left(CustomErrorFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UpdateUserDetailsModel>> updateUserDetails(
    UpdateUserDetailsParams params,
  ) async {
    try {
      final result = await masterGoalDatasource.updateUserDetails(params);
      return Right(result);
    } on DioError catch (e) {
      log("Dio error in updateUserDetails: ${e.message}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("updateUserDetails catch error: ${e.toString()}");
      return Left(CustomErrorFailure(e.toString()));
    }
  }
}
