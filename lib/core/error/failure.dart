import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// abstract class Failure extends Equatable {
//   @override
//   List<Object> get props => [];
// }

class ServerFailure extends Failure {
  const ServerFailure(super.message);

  @override
  List<Object> get props => [];
}

class OfflineFailure extends Failure {
  const OfflineFailure(super.message);

  @override
  List<Object> get props => [];
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure(super.message);

  @override
  List<Object> get props => [];
}

class EmptyCacheFailure extends Failure {
  const EmptyCacheFailure(super.message);

  @override
  List<Object> get props => [];
}

class UsedMobileNumberFailure extends Failure {
  const UsedMobileNumberFailure(super.message);

  @override
  List<Object> get props => [];
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure(super.message);

  @override
  List<Object> get props => [];
}

class NotVerifiedFailure extends Failure {
  const NotVerifiedFailure(super.message);

  @override
  List<Object> get props => [];
}

class CustomErrorFailure extends Failure {
  const CustomErrorFailure(super.message);

  @override
  List<Object> get props => [];
}
