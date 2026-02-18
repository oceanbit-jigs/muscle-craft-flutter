class Api {
  //static const base = 'https://workoutmanager.oceanbitsolutions.com/';
  static const base = 'https://musclecraft-bodyworkout.oceanbitsolutions.com/';

  static const baseurl = '${base}api/';

  ///auth
  static const register = 'user/register';
  static const login = 'user/login';
  static const logout = 'user/logout';
  static const softDelete = 'user/softdelete';

  /// home-user api
  static const dashboard = 'user-home';
  static const workoutDetail = 'workout';
  static const workoutExerciseDetail = 'exercise';
  static const exercise = 'exercise';
  static const showWorkout = 'category';

  ///master goal and focus areas
  static const goal = 'master-goal/list';
  static const focusAreas = 'focus_area';

  ///user details
  static const userDetails = 'user-detail/add';
  static const getUserDetails = 'user/detail';
  static const updateUserDetails = 'user-detail/update';
  static const updateUserProfile = 'user/updateProfile';
}
