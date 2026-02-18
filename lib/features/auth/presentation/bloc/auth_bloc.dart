import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_workout_app/features/auth/domain/usecase/update_user_profile_usecase.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../../../dio/model/success_model.dart';
import '../../domain/model/login_model.dart';
import '../../domain/model/logout_model.dart';
import '../../domain/model/register_model.dart';
import '../../domain/model/update_user_profile_model.dart';
import '../../domain/usecase/delete_account_usecase.dart';
import '../../domain/usecase/login_usecase.dart';
import '../../domain/usecase/logout_usecase.dart';
import '../../domain/usecase/register_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUserUsecase registerUserUsecase;
  final LoginUserUsecase loginUserUsecase;
  final LogoutUserUsecase logoutUserUsecase;
  final UpdateUserProfileUsecase profileUsecase;
  final DeleteAccountUseCase addDeleteAccountUseCase;

  AuthBloc(
    this.registerUserUsecase,
    this.loginUserUsecase,
    this.logoutUserUsecase,
    this.profileUsecase,
    this.addDeleteAccountUseCase,
  ) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is RegisterUserEvent) {
        emit(RegisterUserLoadingState());

        final failureOrSuccess = await registerUserUsecase(event.parameters);

        emit(_mapFailureOrSuccessToState(failureOrSuccess));
      }
    });

    on<LoginUserEvent>((event, emit) async {
      emit(LoginUserLoadingState());

      final failureOrSuccess = await loginUserUsecase(event.parameters);

      emit(_mapLoginFailureOrSuccessToState(failureOrSuccess));
    });

    on<LogoutUserEvent>((event, emit) async {
      emit(LogoutUserLoadingState());

      final result = await logoutUserUsecase(event.parameters);

      result.fold(
        (failure) => emit(LogoutUserErrorState(failure.message)),
        (response) => emit(LogoutUserSuccessState(response)),
      );
    });

    on<UpdateUserProfileEvent>((event, emit) async {
      emit(UpdateUserProfileLoadingState());

      final Either<Failure, UserResponse> failureOrSuccess =
          await profileUsecase(event.parameters);

      failureOrSuccess.fold(
        (failure) => emit(UpdateUserProfileErrorState(failure.message)),
        (response) => emit(UpdateUserProfileSuccessState(response)),
      );
    });

    on<FetchDeleteAccountEvent>((event, emit) async {
      emit(DeleteAccountLoadingState());
      final failureOrGet = await addDeleteAccountUseCase(const NoParameters());
      emit(_deleteAccountFailureOrSuccessToState(failureOrGet));
    });
  }

  AuthState _mapFailureOrSuccessToState(
    Either<Failure, RegisterResponseModel> either,
  ) {
    return either.fold(
      (failure) => RegisterUserErrorState(failure.message),
      (response) => RegisterUserSuccessState(response),
    );
  }

  AuthState _mapLoginFailureOrSuccessToState(
    Either<Failure, LoginResponseModel> either,
  ) {
    return either.fold(
      (failure) => LoginUserErrorState(failure.message),
      (response) => LoginUserSuccessState(response),
    );
  }

  AuthState _deleteAccountFailureOrSuccessToState(
    Either<Failure, SuccessModel> either,
  ) {
    return either.fold(
      (failure) => DeleteAccountErrorState(error: failure.message),
      (accountModel) {
        return DeleteAccountLoadedState(data: accountModel);
      },
    );
  }
}
