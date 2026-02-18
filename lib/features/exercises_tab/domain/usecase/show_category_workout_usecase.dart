import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../model/show_category_model.dart';
import '../repository/exercise_repository.dart';

class GetCategoryDetailsUseCase {
  final BaseExerciseRepository baseWorkoutCategoryRepository;

  GetCategoryDetailsUseCase(this.baseWorkoutCategoryRepository);

  Future<Either<Failure, CategoryModel>> call({required int categoryId}) async {
    return await baseWorkoutCategoryRepository.getCategoryDetails(
      categoryId: categoryId,
    );
  }
}
