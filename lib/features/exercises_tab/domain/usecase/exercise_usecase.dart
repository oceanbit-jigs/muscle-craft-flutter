import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/exercise_model.dart';
import '../repository/exercise_repository.dart';

// class GetExerciseDataUseCase extends BaseUseCase<ExerciseResponseModel, int> {
//   final BaseExerciseRepository baseExerciseRepository;
//
//   GetExerciseDataUseCase(this.baseExerciseRepository);
//
//   @override
//   Future<Either<Failure, ExerciseResponseModel>> call(
//     int page,
//     int focusareaid,
//   ) async {
//     return await baseExerciseRepository.getExercises(
//       page: page,
//       focusAreaId: focusareaid,
//     );
//   }
// }

class GetExerciseDataUseCase {
  final BaseExerciseRepository baseExerciseRepository;

  GetExerciseDataUseCase(this.baseExerciseRepository);

  Future<Either<Failure, ExerciseResponseModel>> call({
    required int page,
    int? focusAreaId,
  }) async {
    return await baseExerciseRepository.getExercises(
      page: page,
      focusAreaId: focusAreaId,
    );
  }
}
