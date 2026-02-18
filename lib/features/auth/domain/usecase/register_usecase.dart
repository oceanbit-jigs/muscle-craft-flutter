import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/register_model.dart';
import '../repository/auth_repository.dart';

class RegisterUserUsecase
    extends BaseUseCase<RegisterResponseModel, RegisterUserParameter> {
  final BaseRegisterRepository baseRegisterRepository;

  RegisterUserUsecase(this.baseRegisterRepository);

  @override
  Future<Either<Failure, RegisterResponseModel>> call(
    RegisterUserParameter parameters,
  ) async {
    return await baseRegisterRepository.registerUser(parameters);
  }
}

class RegisterUserParameter extends Equatable {
  final String name;
  final String email;
  final String? phone;
  final String password;
  final String confirmPassword;
  final File? image;

  const RegisterUserParameter({
    required this.name,
    required this.email,
    this.phone,
    required this.password,
    required this.confirmPassword,
    this.image,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    phone,
    password,
    confirmPassword,
    image,
  ];
}
