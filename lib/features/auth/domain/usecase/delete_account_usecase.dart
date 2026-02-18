import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../../../dio/model/success_model.dart';
import '../repository/auth_repository.dart';

class DeleteAccountUseCase extends BaseUseCase<SuccessModel, NoParameters> {
  final BaseRegisterRepository baseRegisterRepository;

  DeleteAccountUseCase(this.baseRegisterRepository);

  @override
  Future<Either<Failure, SuccessModel>> call(NoParameters parameters) async {
    return await baseRegisterRepository.deleteAccount(parameters);
  }
}
