import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/update_user_profile_model.dart';
import '../repository/auth_repository.dart';

/// UseCase for updating user details
class UpdateUserProfileUsecase
    extends BaseUseCase<UserResponse, UpdateUserProfileParams> {
  final BaseRegisterRepository baseUserRepository;

  UpdateUserProfileUsecase(this.baseUserRepository);

  @override
  Future<Either<Failure, UserResponse>> call(
    UpdateUserProfileParams parameters,
  ) async {
    return await baseUserRepository.updateUserProfile(parameters);
  }
}

class UpdateUserProfileParams extends Equatable {
  final int userId;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;

  const UpdateUserProfileParams({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [userId, name, email, phone, imageUrl];
}
