import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/strings.dart';
import '../../domain/model/exercise_model.dart';
import '../../domain/model/show_category_model.dart';
import '../../domain/repository/exercise_repository.dart';
import '../datasource/exercise_datasource.dart';

class ExerciseRepositoryImpl extends BaseExerciseRepository {
  final BaseExerciseDatasource exerciseDatasource;

  ExerciseRepositoryImpl(this.exerciseDatasource);

  ExerciseResponseModel? _cachedExerciseData;
  CategoryModel? _cachedCategoryData;

  ExerciseResponseModel? get exerciseData => _cachedExerciseData;
  CategoryModel? get categoryData => _cachedCategoryData;

  set exerciseData(ExerciseResponseModel? data) {
    _cachedExerciseData = data;
  }

  set categoryData(CategoryModel? data) {
    _cachedCategoryData = data;
  }

  void clearExerciseRepo() {
    _cachedExerciseData = null;
  }

  void clearCategoryRepo() {
    _cachedCategoryData = null;
  }

  @override
  Future<Either<Failure, ExerciseResponseModel>> getExercises({
    int page = 1,
    int? focusAreaId,
  }) async {
    try {
      final result = await exerciseDatasource.getExercises(
        page: page,
        focusAreaId: focusAreaId,
      );

      if (page == 1) {
        exerciseData = result;
      }

      return Right(result);
    } on ServerException catch (e) {
      log("ServerException in Repository: ${e.message}");
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      log("DioException in Repository: ${e.message}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("Unknown Repository Error: ${e.toString()}");
      return Left(CustomErrorFailure("Unexpected error occurred"));
    }
  }

  @override
  Future<Either<Failure, CategoryModel>> getCategoryDetails({
    required int categoryId,
  }) async {
    try {
      final result = await exerciseDatasource.getCategoryDetails(
        categoryId: categoryId,
      );

      categoryData = result;

      return Right(result);
    } on ServerException catch (e) {
      log("ServerException in Category Repository: ${e.message}");
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      log("DioException in Category Repository: ${e.message}");
      return Left(ServerFailure(Stringss.serverFailureMessage));
    } catch (e) {
      log("Unknown Category Repository Error: ${e.toString()}");
      return Left(CustomErrorFailure("Unexpected error occurred"));
    }
  }
}
