import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/list_goals_model.dart';
import '../repository/user_details_repository.dart';

class GetMasterGoalUseCase
    extends BaseUseCase<MasterGoalResponse, NoParameters> {
  final BaseMasterGoalRepository baseMasterGoalRepository;

  GetMasterGoalUseCase(this.baseMasterGoalRepository);

  @override
  Future<Either<Failure, MasterGoalResponse>> call(
    NoParameters parameters,
  ) async {
    return await baseMasterGoalRepository.getMasterGoals();
  }
}
