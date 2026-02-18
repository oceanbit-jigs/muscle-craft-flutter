import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../model/add_user_details_model.dart';
import '../repository/user_details_repository.dart';

/// Use case to save user details
class SaveUserDetailsUsecase
    extends BaseUseCase<UserDetailResponse, SaveUserDetailsParams> {
  final BaseMasterGoalRepository repository;

  SaveUserDetailsUsecase(this.repository);

  @override
  Future<Either<Failure, UserDetailResponse>> call(
    SaveUserDetailsParams params,
  ) async {
    return await repository.saveUserDetails(params);
  }
}

class SaveUserDetailsParams extends Equatable {
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
  final bool isNotificationEnabled;

  const SaveUserDetailsParams({
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
    required this.isNotificationEnabled,
  });

  @override
  List<Object?> get props => [
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
    isNotificationEnabled,
  ];
}

/// NoParams class for usecases that don't require input
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
