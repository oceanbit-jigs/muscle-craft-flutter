import 'package:fitness_workout_app/features/auth/data/datasource/auth_datasource.dart';
import 'package:fitness_workout_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:fitness_workout_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fitness_workout_app/features/auth/domain/usecase/delete_account_usecase.dart';
import 'package:fitness_workout_app/features/auth/domain/usecase/login_usecase.dart';
import 'package:fitness_workout_app/features/auth/domain/usecase/logout_usecase.dart';
import 'package:fitness_workout_app/features/auth/domain/usecase/register_usecase.dart';
import 'package:fitness_workout_app/features/auth/domain/usecase/update_user_profile_usecase.dart';
import 'package:fitness_workout_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fitness_workout_app/features/exercises_tab/data/repository/exercise_repository_impl.dart';
import 'package:fitness_workout_app/features/exercises_tab/domain/repository/exercise_repository.dart';
import 'package:fitness_workout_app/features/exercises_tab/domain/usecase/exercise_usecase.dart';
import 'package:fitness_workout_app/features/exercises_tab/presentation/bloc/exercise_bloc.dart';
import 'package:fitness_workout_app/features/user_details/data/repository/user_details_repository_impl.dart';
import 'package:fitness_workout_app/features/user_details/domain/repository/user_details_repository.dart';
import 'package:fitness_workout_app/features/user_details/domain/usecase/get_user_details_usecase.dart';
import 'package:fitness_workout_app/features/user_details/domain/usecase/list_focus_area_model.dart';
import 'package:fitness_workout_app/features/user_details/domain/usecase/list_goal_usecase.dart';
import 'package:fitness_workout_app/features/user_details/domain/usecase/update_user_details_usecase.dart';
import 'package:fitness_workout_app/features/user_details/domain/usecase/user_details_usecase.dart';
import 'package:fitness_workout_app/features/user_details/presentations/bloc/user_details_bloc.dart';
import 'package:fitness_workout_app/features/workout_tab/data/datasource/workout_home_datasource.dart';
import 'package:fitness_workout_app/features/workout_tab/data/repository/workout_home_repository_impl.dart';
import 'package:fitness_workout_app/features/workout_tab/domain/repository/workout_home_repository.dart';
import 'package:fitness_workout_app/features/workout_tab/domain/usecase/workout_details_usecase.dart';
import 'package:fitness_workout_app/features/workout_tab/domain/usecase/workout_excercise_details_usecase.dart';
import 'package:fitness_workout_app/features/workout_tab/presentation/bloc/dashboard_bloc.dart';
import 'package:get_it/get_it.dart';

import 'features/exercises_tab/data/datasource/exercise_datasource.dart';
import 'features/exercises_tab/domain/usecase/show_category_workout_usecase.dart';
import 'features/user_details/data/datasource/user_details_datasource.dart';
import 'features/workout_tab/domain/usecase/workout_home_usecase.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  ///Datasources

  // sl.registerLazySingleton<BaseCategoryDatasource>(
  //     () => CategoryDatasourceImpl());

  sl.registerLazySingleton<BaseDashboardDatasource>(
    () => DashboardDatasourceImpl(),
  );

  sl.registerLazySingleton<BaseExerciseDatasource>(
    () => ExerciseDatasourceImpl(),
  );

  sl.registerLazySingleton<BaseRegisterDatasource>(() => RegisterDatasource());

  sl.registerLazySingleton<BaseMasterGoalDatasource>(
    () => MasterGoalDatasourceImpl(),
  );

  ///RepositoryIMPL

  // sl.registerLazySingleton<BaseCategoryRepository>(
  //     () => CategoryRepositoryImpl(sl()));

  sl.registerLazySingleton<BaseDashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<BaseExerciseRepository>(
    () => ExerciseRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<BaseRegisterRepository>(
    () => RegisterRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<BaseMasterGoalRepository>(
    () => MasterGoalRepositoryImpl(sl()),
  );

  ///Usecases

  // sl.registerLazySingleton<AddCategoryUsecase>(
  //     () => AddCategoryUsecase(sl()));

  sl.registerLazySingleton<GetDashboardDataUseCase>(
    () => GetDashboardDataUseCase(sl()),
  );

  sl.registerLazySingleton<GetExerciseDataUseCase>(
    () => GetExerciseDataUseCase(sl()),
  );

  sl.registerLazySingleton<GetWorkoutDetailUseCase>(
    () => GetWorkoutDetailUseCase(sl()),
  );

  sl.registerLazySingleton<GetWorkoutExerciseDetailUseCase>(
    () => GetWorkoutExerciseDetailUseCase(sl()),
  );

  sl.registerLazySingleton<RegisterUserUsecase>(
    () => RegisterUserUsecase(sl()),
  );

  sl.registerLazySingleton<LoginUserUsecase>(() => LoginUserUsecase(sl()));

  sl.registerLazySingleton<GetMasterGoalUseCase>(
    () => GetMasterGoalUseCase(sl()),
  );

  sl.registerLazySingleton<GetFocusAreaUseCase>(
    () => GetFocusAreaUseCase(sl()),
  );

  sl.registerLazySingleton<SaveUserDetailsUsecase>(
    () => SaveUserDetailsUsecase(sl()),
  );

  sl.registerLazySingleton<GetUserDetailsUseCase>(
    () => GetUserDetailsUseCase(sl()),
  );

  sl.registerLazySingleton<LogoutUserUsecase>(() => LogoutUserUsecase(sl()));

  sl.registerLazySingleton<UpdateUserDetailsUsecase>(
    () => UpdateUserDetailsUsecase(sl()),
  );

  sl.registerLazySingleton<UpdateUserProfileUsecase>(
    () => UpdateUserProfileUsecase(sl()),
  );

  sl.registerLazySingleton<GetCategoryDetailsUseCase>(
    () => GetCategoryDetailsUseCase(sl()),
  );

  sl.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(sl()),
  );

  ///Blocks

  //sl.registerFactory<CategoryBloc>(() => CategoryBloc(sl(),sl(),sl(),sl()));

  sl.registerFactory<DashboardBloc>(() => DashboardBloc(sl(), sl(), sl()));
  sl.registerFactory<ExerciseBloc>(() => ExerciseBloc(sl(), sl()));
  sl.registerFactory<AuthBloc>(() => AuthBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<UserDetailsBloc>(
    () => UserDetailsBloc(sl(), sl(), sl(), sl(), sl()),
  );
}
