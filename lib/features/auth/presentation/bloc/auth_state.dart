part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

final class AuthInitial extends AuthState {
  @override
  List<Object> get props => [];
}

class RegisterUserLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class RegisterUserSuccessState extends AuthState {
  final RegisterResponseModel responseModel;

  const RegisterUserSuccessState(this.responseModel);

  @override
  List<Object?> get props => [responseModel];
}

class RegisterUserErrorState extends AuthState {
  final String message;

  const RegisterUserErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginUserLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class LoginUserSuccessState extends AuthState {
  final LoginResponseModel responseModel;

  const LoginUserSuccessState(this.responseModel);

  @override
  List<Object?> get props => [responseModel];
}

class LoginUserErrorState extends AuthState {
  final String message;

  const LoginUserErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class LogoutUserLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class LogoutUserSuccessState extends AuthState {
  final LogoutResponse responseModel;

  const LogoutUserSuccessState(this.responseModel);

  @override
  List<Object?> get props => [responseModel];
}

class LogoutUserErrorState extends AuthState {
  final String message;

  const LogoutUserErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class UpdateUserProfileLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class UpdateUserProfileSuccessState extends AuthState {
  final UserResponse responseModel;

  const UpdateUserProfileSuccessState(this.responseModel);

  @override
  List<Object?> get props => [responseModel];
}

class UpdateUserProfileErrorState extends AuthState {
  final String message;

  const UpdateUserProfileErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

class DeleteAccountLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class DeleteAccountLoadedState extends AuthState {
  final SuccessModel? data;
  const DeleteAccountLoadedState({this.data});
  @override
  List<Object?> get props => [];
}

class DeleteAccountErrorState extends AuthState {
  final dynamic error;
  const DeleteAccountErrorState({this.error});
  @override
  List<Object?> get props => [];
}
