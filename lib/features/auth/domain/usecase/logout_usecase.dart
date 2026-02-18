import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/logout_model.dart';
import '../repository/auth_repository.dart';

/// UseCase for logging out the user
class LogoutUserUsecase
    extends BaseUseCase<LogoutResponse, LogoutUserParameter> {
  final BaseRegisterRepository baseAuthRepository;

  LogoutUserUsecase(this.baseAuthRepository);

  @override
  Future<Either<Failure, LogoutResponse>> call(
    LogoutUserParameter params,
  ) async {
    return await baseAuthRepository.logoutUser(params.token);
  }
}

class LogoutUserParameter extends Equatable {
  final String token;

  const LogoutUserParameter({required this.token});

  @override
  List<Object?> get props => [token];
}
