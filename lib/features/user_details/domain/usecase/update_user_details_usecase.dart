import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/update_user_details_model.dart';
import '../repository/user_details_repository.dart';

/// ✅ Use case to update user details
class UpdateUserDetailsUsecase
    extends BaseUseCase<UpdateUserDetailsModel, UpdateUserDetailsParams> {
  final BaseMasterGoalRepository repository;

  UpdateUserDetailsUsecase(this.repository);

  @override
  Future<Either<Failure, UpdateUserDetailsModel>> call(
    UpdateUserDetailsParams params,
  ) async {
    return await repository.updateUserDetails(params);
  }
}

class UpdateUserDetailsParams extends Equatable {
  final int userDetailId;
  final String userName;
  final String gender;
  final int age;
  final double height;
  final String heightUnit;
  final double currentWeight;
  final String currentWeightUnit;
  final double targetWeight;
  final String targetWeightUnit;
  final List<int> goalIds;
  final List<int> focusAreaIds;

  const UpdateUserDetailsParams({
    required this.userDetailId,
    required this.userName,
    required this.gender,
    required this.age,
    required this.height,
    required this.heightUnit,
    required this.currentWeight,
    required this.currentWeightUnit,
    required this.targetWeight,
    required this.targetWeightUnit,
    required this.goalIds,
    required this.focusAreaIds,
  });

  @override
  List<Object?> get props => [
    userDetailId,
    userName,
    gender,
    age,
    height,
    heightUnit,
    currentWeight,
    currentWeightUnit,
    targetWeight,
    targetWeightUnit,
    goalIds,
    focusAreaIds,
  ];
}
