import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../model/exercise_model.dart';
import '../model/show_category_model.dart';

abstract class BaseExerciseRepository {
  Future<Either<Failure, ExerciseResponseModel>> getExercises({
    int page = 1,
    int? focusAreaId,
  });
  Future<Either<Failure, CategoryModel>> getCategoryDetails({
    required int categoryId,
  });
}
