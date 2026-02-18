part of 'user_details_bloc.dart';

abstract class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();

  @override
  List<Object?> get props => [];
}

final class GetMasterGoalEvent extends UserDetailsEvent {}

final class GetFocusAreaEvent extends UserDetailsEvent {}

final class SaveUserDetailsEvent extends UserDetailsEvent {
  final SaveUserDetailsParams params;

  const SaveUserDetailsEvent(this.params);

  @override
  List<Object?> get props => [params];
}

final class GetUserDetailsEvent extends UserDetailsEvent {}

final class UpdateUserDetailsEvent extends UserDetailsEvent {
  final UpdateUserDetailsParams params;

  const UpdateUserDetailsEvent(this.params);

  @override
  List<Object?> get props => [params];
}
