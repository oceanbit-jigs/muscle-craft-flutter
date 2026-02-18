part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();
}

final class DashboardInitial extends DashboardState {
  @override
  List<Object> get props => [];
}

class DashboardLoading extends DashboardState {
  @override
  List<Object?> get props => [];
}

class DashboardLoaded extends DashboardState {
  final DashboardResponse dashboard;

  const DashboardLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkoutDetailLoading extends DashboardState {
  @override
  List<Object?> get props => [];
}

class WorkoutDetailLoaded extends DashboardState {
  final WorkoutDetailResponse workoutDetail;

  const WorkoutDetailLoaded(this.workoutDetail);

  @override
  List<Object?> get props => [workoutDetail];
}

class WorkoutDetailError extends DashboardState {
  final String message;

  const WorkoutDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

class WorkoutExerciseDetailLoading extends DashboardState {
  @override
  List<Object?> get props => [];
}

class WorkoutExerciseDetailLoaded extends DashboardState {
  final WorkoutExerciseDetailsResponse exerciseDetail;

  const WorkoutExerciseDetailLoaded(this.exerciseDetail);

  @override
  List<Object?> get props => [exerciseDetail];
}

class WorkoutExerciseDetailError extends DashboardState {
  final String message;

  const WorkoutExerciseDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
