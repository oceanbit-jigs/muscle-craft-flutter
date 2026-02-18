part of 'exercise_bloc.dart';

abstract class ExerciseEvent extends Equatable {
  const ExerciseEvent();
  @override
  List<Object> get props => [];
}

// class GetExercisesEvent extends ExerciseEvent {}

class GetExercisesEvent extends ExerciseEvent {
  final int? focusAreaId;

  const GetExercisesEvent({this.focusAreaId});
}

class LoadMoreExercisesEvent extends ExerciseEvent {}

class RefreshExercisesEvent extends ExerciseEvent {}

class GetCategoryDetailsEvent extends ExerciseEvent {
  final int categoryId;

  const GetCategoryDetailsEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class RefreshCategoryEvent extends ExerciseEvent {
  final int categoryId;

  const RefreshCategoryEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}
