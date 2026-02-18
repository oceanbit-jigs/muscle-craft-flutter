part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class FetchDashboardEvent extends DashboardEvent {
  const FetchDashboardEvent();

  @override
  List<Object?> get props => [];
}

class RefreshDashboardEvent extends DashboardEvent {
  const RefreshDashboardEvent();

  @override
  List<Object?> get props => [];
}

class FetchWorkoutDetailEvent extends DashboardEvent {
  final int workoutId;

  const FetchWorkoutDetailEvent(this.workoutId);

  @override
  List<Object?> get props => [workoutId];
}

/// Refresh Workout Detail
class RefreshWorkoutDetailEvent extends DashboardEvent {
  final int workoutId;

  const RefreshWorkoutDetailEvent(this.workoutId);

  @override
  List<Object?> get props => [workoutId];
}

/// Fetch Exercise Detail
class FetchWorkoutExerciseDetailEvent extends DashboardEvent {
  final int exerciseId;

  const FetchWorkoutExerciseDetailEvent(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}

/// Refresh Exercise Detail
class RefreshWorkoutExerciseDetailEvent extends DashboardEvent {
  final int exerciseId;

  const RefreshWorkoutExerciseDetailEvent(this.exerciseId);

  @override
  List<Object?> get props => [exerciseId];
}
