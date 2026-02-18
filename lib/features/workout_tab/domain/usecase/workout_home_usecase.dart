import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/workout_home_model.dart';
import '../repository/workout_home_repository.dart';

class GetDashboardDataUseCase
    extends BaseUseCase<DashboardResponse, NoParameters> {
  final BaseDashboardRepository baseDashboardRepository;

  GetDashboardDataUseCase(this.baseDashboardRepository);

  @override
  Future<Either<Failure, DashboardResponse>> call(
    NoParameters parameters,
  ) async {
    return await baseDashboardRepository.getDashboardData();
  }
}
