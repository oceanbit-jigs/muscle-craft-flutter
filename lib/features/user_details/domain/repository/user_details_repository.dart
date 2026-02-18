import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../model/add_user_details_model.dart';
import '../model/list_focus_area_model.dart';
import '../model/list_goals_model.dart';
import '../model/update_user_details_model.dart';
import '../model/user_full_details_model.dart';
import '../usecase/update_user_details_usecase.dart';
import '../usecase/user_details_usecase.dart';

abstract class BaseMasterGoalRepository {
  Future<Either<Failure, MasterGoalResponse>> getMasterGoals();
  Future<Either<Failure, FocusAreaResponse>> getFocusAreas();

  Future<Either<Failure, UserDetailResponse>> saveUserDetails(
    SaveUserDetailsParams params,
  );

  Future<Either<Failure, UserDetailsResponse>> getUserDetails();
  Future<Either<Failure, UpdateUserDetailsModel>> updateUserDetails(
    UpdateUserDetailsParams params,
  );
}
