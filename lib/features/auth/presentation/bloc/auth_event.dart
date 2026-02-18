part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class RegisterUserEvent extends AuthEvent {
  final RegisterUserParameter parameters;

  const RegisterUserEvent(this.parameters);

  @override
  List<Object?> get props => [parameters];
}

class LoginUserEvent extends AuthEvent {
  final LoginUserParameter parameters;

  const LoginUserEvent(this.parameters);

  @override
  List<Object?> get props => [parameters];
}

class LogoutUserEvent extends AuthEvent {
  final LogoutUserParameter parameters;

  const LogoutUserEvent(this.parameters);

  @override
  List<Object?> get props => [parameters];
}

class UpdateUserProfileEvent extends AuthEvent {
  final UpdateUserProfileParams parameters;

  const UpdateUserProfileEvent(this.parameters);

  @override
  List<Object?> get props => [parameters];
}

class FetchDeleteAccountEvent extends AuthEvent {
  @override
  final BuildContext context;
  const FetchDeleteAccountEvent({required this.context});
  @override
  List<Object?> get props => [];
}
