part of 'user_details_bloc.dart';

abstract class UserDetailsState extends Equatable {
  const UserDetailsState();
}

final class UserDetailsInitial extends UserDetailsState {
  @override
  List<Object> get props => [];
}

final class MasterGoalLoadingState extends UserDetailsState {
  @override
  List<Object> get props => [];
}

final class MasterGoalLoadedState extends UserDetailsState {
  final MasterGoalResponse masterGoalResponse;

  const MasterGoalLoadedState(this.masterGoalResponse);

  @override
  List<Object?> get props => [masterGoalResponse];
}

final class MasterGoalErrorState extends UserDetailsState {
  final String message;

  const MasterGoalErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

final class FocusAreaLoadingState extends UserDetailsState {
  @override
  List<Object> get props => [];
}

final class FocusAreaLoadedState extends UserDetailsState {
  final FocusAreaResponse focusAreaResponse;

  const FocusAreaLoadedState(this.focusAreaResponse);

  @override
  List<Object?> get props => [focusAreaResponse];
}

final class FocusAreaErrorState extends UserDetailsState {
  final String message;

  const FocusAreaErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

final class SaveUserDetailsLoadingState extends UserDetailsState {
  @override
  List<Object> get props => [];
}

final class SaveUserDetailsSuccessState extends UserDetailsState {
  final UserDetailResponse userDetailResponse;
  const SaveUserDetailsSuccessState(this.userDetailResponse);

  @override
  List<Object?> get props => [userDetailResponse];
}

final class SaveUserDetailsErrorState extends UserDetailsState {
  final String message;
  const SaveUserDetailsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

final class GetUserDetailsLoadingState extends UserDetailsState {
  @override
  List<Object> get props => [];
}

final class GetUserDetailsSuccessState extends UserDetailsState {
  final UserDetailsResponse userDetailResponse;

  const GetUserDetailsSuccessState(this.userDetailResponse);

  @override
  List<Object?> get props => [userDetailResponse];
}

final class GetUserDetailsErrorState extends UserDetailsState {
  final String message;

  const GetUserDetailsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

final class UpdateUserDetailsLoadingState extends UserDetailsState {
  @override
  List<Object> get props => [];
}

final class UpdateUserDetailsSuccessState extends UserDetailsState {
  final UpdateUserDetailsModel updateUserDetailsModel;

  const UpdateUserDetailsSuccessState(this.updateUserDetailsModel);

  @override
  List<Object?> get props => [updateUserDetailsModel];
}

final class UpdateUserDetailsErrorState extends UserDetailsState {
  final String message;

  const UpdateUserDetailsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
