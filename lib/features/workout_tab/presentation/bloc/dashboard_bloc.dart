import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fitness_workout_app/features/exercises_tab/domain/usecase/exercise_usecase.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/base_usecase.dart';
import '../../domain/model/workout_details_model.dart';
import '../../domain/model/workout_exercise_details_model.dart';
import '../../domain/model/workout_home_model.dart';
import '../../domain/usecase/workout_details_usecase.dart';
import '../../domain/usecase/workout_excercise_details_usecase.dart';
import '../../domain/usecase/workout_home_usecase.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardDataUseCase getDashboardDataUseCase;
  final GetWorkoutDetailUseCase getWorkoutDetailUseCase;
  final GetWorkoutExerciseDetailUseCase getWorkoutExerciseDetailUseCase;

  DashboardBloc(
    this.getDashboardDataUseCase,
    this.getWorkoutDetailUseCase,
    this.getWorkoutExerciseDetailUseCase,
  ) : super(DashboardInitial()) {
    // Fetch Event
    on<FetchDashboardEvent>((event, emit) async {
      emit(DashboardLoading());
      final result = await getDashboardDataUseCase(NoParameters());
      result.fold(
        (failure) => emit(DashboardError(_mapFailureToMessage(failure))),
        (dashboard) => emit(DashboardLoaded(dashboard)),
      );
    });

    on<RefreshDashboardEvent>((event, emit) async {
      emit(DashboardLoading());
      final result = await getDashboardDataUseCase(NoParameters());
      result.fold(
        (failure) => emit(DashboardError(_mapFailureToMessage(failure))),
        (dashboard) => emit(DashboardLoaded(dashboard)),
      );
    });

    on<FetchWorkoutDetailEvent>((event, emit) async {
      emit(WorkoutDetailLoading());
      final result = await getWorkoutDetailUseCase(
        WorkoutDetailParams(workoutId: event.workoutId),
      );

      result.fold(
        (failure) => emit(WorkoutDetailError(_mapFailureToMessage(failure))),
        (workout) => emit(WorkoutDetailLoaded(workout)),
      );
    });

    on<RefreshWorkoutDetailEvent>((event, emit) async {
      emit(WorkoutDetailLoading());
      final result = await getWorkoutDetailUseCase(
        WorkoutDetailParams(workoutId: event.workoutId),
      );

      result.fold(
        (failure) => emit(WorkoutDetailError(_mapFailureToMessage(failure))),
        (workout) => emit(WorkoutDetailLoaded(workout)),
      );
    });

    on<FetchWorkoutExerciseDetailEvent>((event, emit) async {
      emit(WorkoutExerciseDetailLoading());
      final result = await getWorkoutExerciseDetailUseCase(
        WorkoutExerciseDetailParams(exerciseId: event.exerciseId),
      );

      result.fold(
        (failure) =>
            emit(WorkoutExerciseDetailError(_mapFailureToMessage(failure))),
        (exerciseDetail) => emit(WorkoutExerciseDetailLoaded(exerciseDetail)),
      );
    });

    on<RefreshWorkoutExerciseDetailEvent>((event, emit) async {
      emit(WorkoutExerciseDetailLoading());
      final result = await getWorkoutExerciseDetailUseCase(
        WorkoutExerciseDetailParams(exerciseId: event.exerciseId),
      );

      result.fold(
        (failure) =>
            emit(WorkoutExerciseDetailError(_mapFailureToMessage(failure))),
        (exerciseDetail) => emit(WorkoutExerciseDetailLoaded(exerciseDetail)),
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
