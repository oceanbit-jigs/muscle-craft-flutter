import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../domain/model/add_user_details_model.dart';
import '../../domain/model/list_focus_area_model.dart';
import '../../domain/model/list_goals_model.dart';
import '../../domain/model/update_user_details_model.dart';
import '../../domain/model/user_full_details_model.dart';
import '../../domain/usecase/get_user_details_usecase.dart';
import '../../domain/usecase/list_focus_area_model.dart';
import '../../domain/usecase/list_goal_usecase.dart';
import '../../domain/usecase/update_user_details_usecase.dart';
import '../../domain/usecase/user_details_usecase.dart';

part 'user_details_event.dart';
part 'user_details_state.dart';

class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final GetMasterGoalUseCase getMasterGoalUseCase;
  final GetFocusAreaUseCase getFocusAreaUseCase;
  final SaveUserDetailsUsecase saveUserDetailsUsecase;
  final GetUserDetailsUseCase getUserDetailsUsecase;
  final UpdateUserDetailsUsecase updateUserDetailsUsecase;

  MasterGoalResponse? masterGoalCache;
  FocusAreaResponse? focusAreaCache;

  UserDetailsBloc(
    this.getMasterGoalUseCase,
    this.getFocusAreaUseCase,
    this.saveUserDetailsUsecase,
    this.getUserDetailsUsecase,
    this.updateUserDetailsUsecase,
  ) : super(UserDetailsInitial()) {
    on<GetMasterGoalEvent>((event, emit) async {
      emit(MasterGoalLoadingState());

      final result = await getMasterGoalUseCase(NoParameters());

      result.fold(
        (failure) => emit(MasterGoalErrorState(_mapFailureToMessage(failure))),
        // (data) => emit(MasterGoalLoadedState(data)),
        (data) {
          masterGoalCache = data;
          emit(MasterGoalLoadedState(data));
        },
      );
    });

    on<GetFocusAreaEvent>((event, emit) async {
      emit(FocusAreaLoadingState());

      final result = await getFocusAreaUseCase(NoParameters());

      result.fold(
        (failure) => emit(FocusAreaErrorState(_mapFailureToMessage(failure))),
        //(data) => emit(FocusAreaLoadedState(data)),
        (data) {
          focusAreaCache = data;
          emit(FocusAreaLoadedState(data));
        },
      );
    });

    on<SaveUserDetailsEvent>((event, emit) async {
      emit(SaveUserDetailsLoadingState());

      final result = await saveUserDetailsUsecase(event.params);

      result.fold(
        (failure) =>
            emit(SaveUserDetailsErrorState(_mapFailureToMessage(failure))),
        (data) => emit(SaveUserDetailsSuccessState(data)),
      );
    });

    on<GetUserDetailsEvent>((event, emit) async {
      emit(GetUserDetailsLoadingState());

      final result = await getUserDetailsUsecase(NoParameters());

      result.fold(
        (failure) =>
            emit(GetUserDetailsErrorState(_mapFailureToMessage(failure))),
        (data) => emit(GetUserDetailsSuccessState(data)),
      );
    });

    on<UpdateUserDetailsEvent>((event, emit) async {
      emit(UpdateUserDetailsLoadingState());

      final result = await updateUserDetailsUsecase(event.params);

      result.fold(
        (failure) =>
            emit(UpdateUserDetailsErrorState(_mapFailureToMessage(failure))),
        (data) => emit(UpdateUserDetailsSuccessState(data)),
      );
    });
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is CustomErrorFailure) {
      return failure.message;
    } else {
      return "Unexpected error occurred";
    }
  }
}
