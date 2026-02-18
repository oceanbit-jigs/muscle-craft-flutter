import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

import 'database_model/exercise_session_model.dart';
import 'database_model/workout_session_model.dart';

class WorkoutDatabase {
  static final WorkoutDatabase instance = WorkoutDatabase._init();
  static Database? _database;

  WorkoutDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('workout_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE workout_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        focus_area_id INTEGER NOT NULL,
        focus_area_name TEXT NOT NULL,
        date TEXT NOT NULL,
        total_time_seconds INTEGER NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Exercise Sessions Table
    await db.execute('''
      CREATE TABLE exercise_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_session_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        exercise_name TEXT NOT NULL,
        image_url TEXT,
        total_sets INTEGER NOT NULL DEFAULT 4,
        completed_sets INTEGER NOT NULL DEFAULT 0,
        weights_json TEXT,
        reps_json TEXT,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (workout_session_id) REFERENCES workout_sessions (id) ON DELETE CASCADE
      )
    ''');

    // Daily Timer Table (for tracking total time per day)
    await db.execute('''
      CREATE TABLE daily_timer (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL UNIQUE,
        total_seconds INTEGER NOT NULL DEFAULT 0,
        last_updated TEXT NOT NULL
      )
    ''');
  }

  // ==================== WORKOUT SESSION OPERATIONS ====================

  Future<WorkoutSessionModel> createWorkoutSession(
    WorkoutSessionModel session,
  ) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final sessionWithTimestamps = session.copyWith(
      createdAt: now,
      updatedAt: now,
    );

    final id = await db.insert(
      'workout_sessions',
      sessionWithTimestamps.toMap(),
    );
    return sessionWithTimestamps.copyWith(id: id);
  }

  Future<WorkoutSessionModel?> getActiveSessionForToday(int focusAreaId) async {
    final db = await database;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final result = await db.query(
      'workout_sessions',
      where: 'focus_area_id = ? AND date = ? AND is_completed = 0',
      whereArgs: [focusAreaId, today],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return WorkoutSessionModel.fromMap(result.first);
    }
    return null;
  }

  Future<WorkoutSessionModel?> getSessionById(int id) async {
    final db = await database;
    final result = await db.query(
      'workout_sessions',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return WorkoutSessionModel.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateWorkoutSession(WorkoutSessionModel session) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final updatedSession = session.copyWith(updatedAt: now);

    return await db.update(
      'workout_sessions',
      updatedSession.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<int> updateSessionTimer(int sessionId, int totalSeconds) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.update(
      'workout_sessions',
      {'total_time_seconds': totalSeconds, 'updated_at': now},
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  Future<int> completeWorkoutSession(int sessionId, int totalSeconds) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    return await db.update(
      'workout_sessions',
      {
        'total_time_seconds': totalSeconds,
        'is_completed': 1,
        'updated_at': now,
      },
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  Future<List<WorkoutSessionModel>> getSessionsByDate(String date) async {
    final db = await database;
    final result = await db.query(
      'workout_sessions',
      where: 'date = ?',
      whereArgs: [date],
    );

    return result.map((map) => WorkoutSessionModel.fromMap(map)).toList();
  }

  Future<List<WorkoutSessionModel>> getCompletedSessions() async {
    final db = await database;
    final result = await db.query(
      'workout_sessions',
      where: 'is_completed = 1',
      orderBy: 'created_at DESC',
    );

    return result.map((map) => WorkoutSessionModel.fromMap(map)).toList();
  }

  // ==================== EXERCISE SESSION OPERATIONS ====================

  Future<ExerciseSessionModel> createExerciseSession(
    ExerciseSessionModel exercise,
  ) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final exerciseWithTimestamps = exercise.copyWith(
      createdAt: now,
      updatedAt: now,
    );

    final id = await db.insert(
      'exercise_sessions',
      exerciseWithTimestamps.toMap(),
    );
    return exerciseWithTimestamps.copyWith(id: id);
  }

  Future<List<ExerciseSessionModel>> getExercisesBySessionId(
    int workoutSessionId,
  ) async {
    final db = await database;
    final result = await db.query(
      'exercise_sessions',
      where: 'workout_session_id = ?',
      whereArgs: [workoutSessionId],
    );

    return result.map((map) => ExerciseSessionModel.fromMap(map)).toList();
  }

  Future<ExerciseSessionModel?> getExerciseSession(
    int workoutSessionId,
    int exerciseId,
  ) async {
    final db = await database;
    final result = await db.query(
      'exercise_sessions',
      where: 'workout_session_id = ? AND exercise_id = ?',
      whereArgs: [workoutSessionId, exerciseId],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return ExerciseSessionModel.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateExerciseSession(ExerciseSessionModel exercise) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    final updatedExercise = exercise.copyWith(updatedAt: now);

    return await db.update(
      'exercise_sessions',
      updatedExercise.toMap(),
      where: 'id = ?',
      whereArgs: [exercise.id],
    );
  }

  Future<void> saveOrUpdateExerciseSession(
    ExerciseSessionModel exercise,
  ) async {
    final existing = await getExerciseSession(
      exercise.workoutSessionId,
      exercise.exerciseId,
    );

    if (existing != null) {
      await updateExerciseSession(exercise.copyWith(id: existing.id));
    } else {
      await createExerciseSession(exercise);
    }
  }

  // ==================== DAILY TIMER OPERATIONS ====================

  Future<int> getDailyTimer(String date) async {
    final db = await database;
    final result = await db.query(
      'daily_timer',
      where: 'date = ?',
      whereArgs: [date],
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['total_seconds'] as int;
    }
    return 0;
  }

  Future<void> updateDailyTimer(String date, int totalSeconds) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    await db.insert('daily_timer', {
      'date': date,
      'total_seconds': totalSeconds,
      'last_updated': now,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> resetTimerIfNewDay() async {
    final prefs = await _getLastSavedDate();
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (prefs != today) {
      await _saveLastDate(today);
    }
  }

  Future<String?> _getLastSavedDate() async {
    final db = await database;
    final result = await db.query(
      'daily_timer',
      orderBy: 'last_updated DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['date'] as String?;
    }
    return null;
  }

  Future<void> _saveLastDate(String date) async {
    // This is handled by updateDailyTimer
  }

  Future<List<Map<String, dynamic>>> getExerciseHistoryByExerciseId(
    int exerciseId,
  ) async {
    final db = await database;

    return await db.rawQuery(
      '''
    SELECT 
      e.exercise_name,
      e.completed_sets,
      w.total_time_seconds,
      w.date
    FROM exercise_sessions e
    JOIN workout_sessions w
      ON e.workout_session_id = w.id
    WHERE e.exercise_id = ?
      AND (e.is_completed = 1 OR e.completed_sets > 0)
    ORDER BY w.date DESC
  ''',
      [exerciseId],
    );
  }

  // ==================== CLEANUP OPERATIONS ====================

  Future<void> deleteSession(int sessionId) async {
    final db = await database;
    await db.delete(
      'workout_sessions',
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  Future<void> deleteAllData() async {
    final db = await database;
    await db.delete('exercise_sessions');
    await db.delete('workout_sessions');
    await db.delete('daily_timer');
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
