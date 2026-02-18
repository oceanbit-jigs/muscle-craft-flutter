import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/user_full_details_model.dart';
import '../repository/user_details_repository.dart';

class GetUserDetailsUseCase
    extends BaseUseCase<UserDetailsResponse, NoParameters> {
  final BaseMasterGoalRepository baseUserDetailsRepository;

  GetUserDetailsUseCase(this.baseUserDetailsRepository);

  @override
  Future<Either<Failure, UserDetailsResponse>> call(
    NoParameters parameters,
  ) async {
    return await baseUserDetailsRepository.getUserDetails();
  }
}
