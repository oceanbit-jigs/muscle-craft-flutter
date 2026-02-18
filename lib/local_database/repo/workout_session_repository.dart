import 'dart:convert';
import 'package:intl/intl.dart';

import '../database_model/exercise_session_model.dart';
import '../database_model/workout_session_model.dart';
import '../workout_database.dart';

class WorkoutSessionRepository {
  final WorkoutDatabase _database = WorkoutDatabase.instance;

  String get _today => DateFormat('yyyy-MM-dd').format(DateTime.now());

  // Get or create a session for today
  Future<WorkoutSessionModel> getOrCreateTodaySession({
    required int focusAreaId,
    required String focusAreaName,
  }) async {
    // Check if new day and reset if needed
    await _checkAndResetForNewDay();

    // Check for existing active session today
    final existingSession = await _database.getActiveSessionForToday(
      focusAreaId,
    );

    if (existingSession != null) {
      return existingSession;
    }

    // Create new session
    final newSession = WorkoutSessionModel(
      focusAreaId: focusAreaId,
      focusAreaName: focusAreaName,
      date: _today,
      totalTimeSeconds: 0,
      isCompleted: false,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    return await _database.createWorkoutSession(newSession);
  }

  Future<void> _checkAndResetForNewDay() async {
    await _database.resetTimerIfNewDay();
  }

  // Get saved timer for today
  Future<int> getSavedTimerForToday(int focusAreaId) async {
    final session = await _database.getActiveSessionForToday(focusAreaId);
    return session?.totalTimeSeconds ?? 0;
  }

  // Update session timer
  Future<void> updateSessionTimer(int sessionId, int totalSeconds) async {
    await _database.updateSessionTimer(sessionId, totalSeconds);
    await _database.updateDailyTimer(_today, totalSeconds);
  }

  // Save exercise progress
  Future<void> saveExerciseProgress({
    required int workoutSessionId,
    required int exerciseId,
    required String exerciseName,
    required String imageUrl,
    required int totalSets,
    required int completedSets,
    required List<int> weights,
    required List<int> reps,
    required bool isCompleted,
  }) async {
    final exercise = ExerciseSessionModel(
      workoutSessionId: workoutSessionId,
      exerciseId: exerciseId,
      exerciseName: exerciseName,
      imageUrl: imageUrl,
      totalSets: totalSets,
      completedSets: completedSets,
      weightsJson: jsonEncode(weights),
      repsJson: jsonEncode(reps),
      isCompleted: isCompleted,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    await _database.saveOrUpdateExerciseSession(exercise);
  }

  // Get all exercises for a session
  Future<List<ExerciseSessionModel>> getExercisesForSession(
    int sessionId,
  ) async {
    return await _database.getExercisesBySessionId(sessionId);
  }

  // Complete workout session
  Future<void> completeWorkoutSession(int sessionId, int totalSeconds) async {
    await _database.completeWorkoutSession(sessionId, totalSeconds);
  }

  // Get completed sessions
  Future<List<WorkoutSessionModel>> getCompletedSessions() async {
    return await _database.getCompletedSessions();
  }

  // Get sessions by date
  Future<List<WorkoutSessionModel>> getSessionsByDate(String date) async {
    return await _database.getSessionsByDate(date);
  }

  // Get today's total workout time
  Future<int> getTodayTotalTime() async {
    return await _database.getDailyTimer(_today);
  }

  // Check if should reset timer (new day)
  Future<bool> shouldResetTimer(String lastSavedDate) async {
    return lastSavedDate != _today;
  }
}
