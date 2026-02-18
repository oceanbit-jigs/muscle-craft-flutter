import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/list_focus_area_model.dart';
import '../repository/user_details_repository.dart';

class GetFocusAreaUseCase extends BaseUseCase<FocusAreaResponse, NoParameters> {
  final BaseMasterGoalRepository repository;

  GetFocusAreaUseCase(this.repository);

  @override
  Future<Either<Failure, FocusAreaResponse>> call(
    NoParameters parameters,
  ) async {
    return await repository.getFocusAreas();
  }
}
