import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/login_model.dart';
import '../repository/auth_repository.dart';

class LoginUserUsecase
    extends BaseUseCase<LoginResponseModel, LoginUserParameter> {
  final BaseRegisterRepository baseAuthRepository;

  LoginUserUsecase(this.baseAuthRepository);

  @override
  Future<Either<Failure, LoginResponseModel>> call(
    LoginUserParameter parameters,
  ) async {
    return await baseAuthRepository.loginUser(parameters);
  }
}

class LoginUserParameter extends Equatable {
  final String email;
  final String password;

  const LoginUserParameter({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
