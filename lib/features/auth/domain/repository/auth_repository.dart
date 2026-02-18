import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../../../dio/model/success_model.dart';
import '../../../user_details/domain/usecase/update_user_details_usecase.dart';
import '../model/login_model.dart';
import '../model/logout_model.dart';
import '../model/register_model.dart';
import '../model/update_user_profile_model.dart';
import '../usecase/login_usecase.dart';
import '../usecase/register_usecase.dart';
import '../usecase/update_user_profile_usecase.dart';

abstract class BaseRegisterRepository {
  Future<Either<Failure, RegisterResponseModel>> registerUser(
    RegisterUserParameter parameters,
  );
  Future<Either<Failure, LoginResponseModel>> loginUser(
    LoginUserParameter params,
  );
  Future<Either<Failure, LogoutResponse>> logoutUser(String token);
  Future<Either<Failure, UserResponse>> updateUserProfile(
    UpdateUserProfileParams params,
  );
  Future<Either<Failure, SuccessModel>> deleteAccount(NoParameters parameters);
}
