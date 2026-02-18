part of 'exercise_bloc.dart';

abstract class ExerciseState extends Equatable {
  const ExerciseState();
  @override
  List<Object> get props => [];
}

final class ExerciseInitial extends ExerciseState {
  @override
  List<Object> get props => [];
}

final class ExerciseLoading extends ExerciseState {}

final class ExercisePaginationLoading extends ExerciseState {
  final List<ExerciseModel> oldData;

  const ExercisePaginationLoading(this.oldData);

  @override
  List<Object> get props => [oldData];
}

final class ExerciseLoaded extends ExerciseState {
  final List<ExerciseModel> exercises;
  final bool hasMore;

  const ExerciseLoaded({required this.exercises, required this.hasMore});

  @override
  List<Object> get props => [exercises, hasMore];
}

final class ExerciseError extends ExerciseState {
  final String message;

  const ExerciseError(this.message);

  @override
  List<Object> get props => [message];
}

final class CategoryLoading extends ExerciseState {}

final class CategoryLoaded extends ExerciseState {
  final CategoryModel data;

  const CategoryLoaded(this.data);

  @override
  List<Object> get props => [data];
}

final class CategoryError extends ExerciseState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object> get props => [message];
}

final class CategoryRefreshing extends ExerciseState {
  final CategoryModel oldData;

  const CategoryRefreshing(this.oldData);

  @override
  List<Object> get props => [oldData];
}
