import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../domain/model/exercise_model.dart';
import '../../domain/model/show_category_model.dart';
import '../../domain/usecase/exercise_usecase.dart';
import '../../domain/usecase/show_category_workout_usecase.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

class ExerciseBloc extends Bloc<ExerciseEvent, ExerciseState> {
  final GetExerciseDataUseCase getExerciseDataUseCase;
  final GetCategoryDetailsUseCase getCategoryDetailsUseCase;

  int _page = 1;
  bool _hasMore = true;
  final List<ExerciseModel> _exercises = [];
  int? _focusAreaId;
  CategoryModel? _categoryData;

  ExerciseBloc(this.getExerciseDataUseCase, this.getCategoryDetailsUseCase)
    : super(ExerciseInitial()) {
    on<GetExercisesEvent>((event, emit) async {
      emit(ExerciseLoading());

      _page = 1;
      _hasMore = true;
      _exercises.clear();
      _focusAreaId = event.focusAreaId;

      // final result = await getExerciseDataUseCase(_page, f);

      final result = await getExerciseDataUseCase(
        page: _page,
        focusAreaId: _focusAreaId,
      );

      result.fold(
        (failure) => emit(ExerciseError(_mapFailureToMessage(failure))),
        (response) {
          _exercises.addAll(response.data);
          _hasMore = response.currentPage < response.lastPage;

          emit(ExerciseLoaded(exercises: _exercises, hasMore: _hasMore));
        },
      );
    });

    on<LoadMoreExercisesEvent>((event, emit) async {
      if (!_hasMore || state is ExercisePaginationLoading) return;

      emit(ExercisePaginationLoading(List.from(_exercises)));

      _page++;

      final result = await getExerciseDataUseCase(
        page: _page,
        focusAreaId: _focusAreaId,
      );

      result.fold(
        (failure) => emit(ExerciseError(_mapFailureToMessage(failure))),
        (response) {
          _exercises.addAll(response.data);
          _hasMore = response.currentPage < response.lastPage;

          emit(ExerciseLoaded(exercises: _exercises, hasMore: _hasMore));
        },
      );
    });

    on<RefreshExercisesEvent>((event, emit) async {
      emit(ExerciseLoading());

      _page = 1;
      _hasMore = true;
      _exercises.clear();

      final result = await getExerciseDataUseCase(
        page: _page,
        focusAreaId: _focusAreaId,
      );

      result.fold(
        (failure) => emit(ExerciseError(_mapFailureToMessage(failure))),
        (response) {
          _exercises.addAll(response.data);
          _hasMore = response.currentPage < response.lastPage;

          emit(ExerciseLoaded(exercises: _exercises, hasMore: _hasMore));
        },
      );
    });

    on<GetCategoryDetailsEvent>((event, emit) async {
      emit(CategoryLoading());

      try {
        final result = await getCategoryDetailsUseCase(
          categoryId: event.categoryId,
        );

        result.fold(
          (failure) => emit(CategoryError(_mapFailureToMessage(failure))),
          (data) {
            _categoryData = data;
            emit(CategoryLoaded(data));
          },
        );
      } catch (e) {
        emit(const CategoryError("Unexpected error occurred"));
      }
    });

    on<RefreshCategoryEvent>((event, emit) async {
      if (_categoryData != null) {
        emit(CategoryRefreshing(_categoryData!));
      } else {
        emit(CategoryLoading());
      }

      try {
        final result = await getCategoryDetailsUseCase(
          categoryId: event.categoryId,
        );

        result.fold(
          (failure) => emit(CategoryError(_mapFailureToMessage(failure))),
          (data) {
            _categoryData = data;
            emit(CategoryLoaded(data));
          },
        );
      } catch (e) {
        emit(const CategoryError("Unexpected error occurred"));
      }
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
