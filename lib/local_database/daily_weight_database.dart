// import 'package:intl/intl.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class WeightDB {
//   static final WeightDB instance = WeightDB._init();
//   static Database? _database;
//
//   WeightDB._init();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('weight_log.db');
//     return _database!;
//   }
//
//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//
//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }
//
//   Future _createDB(Database db, int version) async {
//     await db.execute('''
//   CREATE TABLE weight_logs (
//     id INTEGER PRIMARY KEY AUTOINCREMENT,
//     kg REAL NOT NULL,
//     lbs REAL NOT NULL,
//     date TEXT NOT NULL
//   )
// ''');
//
//     await db.execute('''
//     CREATE TABLE custom_trackers (
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       name TEXT NOT NULL,
//       unit TEXT NOT NULL,
//       type TEXT NOT NULL,
//       "values" TEXT NOT NULL
//     )
//   ''');
//
//     await db.execute('''
//     CREATE TABLE custom_tracker_logs (
//       id INTEGER PRIMARY KEY AUTOINCREMENT,
//       tracker_id INTEGER NOT NULL,
//       field_name TEXT NOT NULL,
//       value REAL NOT NULL,
//       date TEXT NOT NULL,
//       FOREIGN KEY(tracker_id) REFERENCES custom_trackers(id)
//     )
//   ''');
//   }
//
//   Future<int> insertWeight(double value, String unit, DateTime date) async {
//     final db = await instance.database;
//
//     double kg;
//     double lbs;
//
//     if (unit == "kg") {
//       kg = value;
//       lbs = value * 2.20462;
//     } else {
//       lbs = value;
//       kg = value / 2.20462;
//     }
//
//     return await db.insert('weight_logs', {
//       'kg': double.parse(kg.toStringAsFixed(1)),
//       'lbs': double.parse(lbs.toStringAsFixed(1)),
//       'date': DateTime(date.year, date.month, date.day).toIso8601String(),
//     });
//   }
//
//   Future<List<Map<String, dynamic>>> getMonthWeights(
//     int year,
//     int month,
//   ) async {
//     final db = await database;
//
//     String start = DateTime(year, month, 1).toIso8601String();
//     String end = DateTime(year, month + 1, 1).toIso8601String();
//
//     return await db.query(
//       "weight_logs",
//       where: "date >= ? AND date < ?",
//       whereArgs: [start, end],
//     );
//   }
//
//   // Fetch by date
//   Future<Map<String, dynamic>?> getByDate(DateTime date) async {
//     final db = await instance.database;
//     final formattedDate = DateTime(
//       date.year,
//       date.month,
//       date.day,
//     ).toIso8601String();
//
//     final res = await db.query(
//       'weight_logs',
//       where: "date LIKE ?",
//       whereArgs: ["$formattedDate%"],
//       limit: 1,
//     );
//
//     if (res.isNotEmpty) return res.first;
//     return null;
//   }
//
//   // Fetch all entries
//   Future<List<Map<String, dynamic>>> getAll() async {
//     final db = await instance.database;
//     return await db.query('weight_logs', orderBy: "date DESC");
//   }
//
//   // Delete entry
//   Future<int> delete(int id) async {
//     final db = await instance.database;
//     return await db.delete('weight_logs', where: 'id = ?', whereArgs: [id]);
//   }
//
//   Future<Map<String, dynamic>?> getLatestWeight() async {
//     final db = await database;
//
//     final result = await db.query('weight_logs', orderBy: 'id DESC', limit: 1);
//
//     return result.isNotEmpty ? result.first : null;
//   }
//
//   Future<int> insertTracker(
//     String name,
//     String unit,
//     String type,
//     List<double> values,
//   ) async {
//     final db = await instance.database;
//
//     return db.insert('custom_trackers', {
//       'name': name,
//       'unit': unit,
//       'type': type,
//       'values': values.toString(),
//     });
//   }
//
//   Future<List<Map<String, dynamic>>> getAllTrackers() async {
//     final db = await instance.database;
//     return await db.query("custom_trackers");
//   }
//
//   Future<int> deleteTracker(int id) async {
//     final db = await instance.database;
//     return await db.delete('custom_trackers', where: 'id = ?', whereArgs: [id]);
//   }
//
//   Future<int> insertCustomTrackerLog({
//     required int trackerId,
//     required String fieldName,
//     required double value,
//     required DateTime date,
//   }) async {
//     final db = await instance.database;
//
//     return await db.insert("custom_tracker_logs", {
//       "tracker_id": trackerId,
//       "field_name": fieldName,
//       "value": value,
//       "date": DateTime(date.year, date.month, date.day).toIso8601String(),
//     });
//   }
//
//   Future<List<double>> getTrackerLogs(int trackerId, String type) async {
//     final db = await instance.database;
//
//     final res = await db.query(
//       "custom_tracker_logs",
//       where: "tracker_id = ?",
//       whereArgs: [trackerId],
//       orderBy: "date ASC",
//     );
//
//     List<Map<String, dynamic>> logs = res.map((row) {
//       return {
//         "value": (row["value"] as num).toDouble(),
//         "date": DateTime.parse(row["date"] as String),
//       };
//     }).toList();
//
//     if (type == "Daily") {
//       Map<int, double> dailyMap = {};
//
//       for (var log in logs) {
//         int day = log["date"].day;
//
//         // Replace the previous value if exists
//         dailyMap[day] = log["value"];
//       }
//
//       final now = DateTime.now();
//       final year = now.year;
//       final month = now.month;
//       final lastDayOfMonth = DateTime(year, month + 1, 0).day;
//
//       return List.generate(lastDayOfMonth, (i) {
//         int day = i + 1;
//         return dailyMap[day] ?? 0;
//       });
//     }
//
//     // if (type == "Weekly") {
//     //   Map<int, double> weekMap = {};
//     //
//     //   for (var log in logs) {
//     //     int day = log["date"].day;
//     //
//     //     int weekIndex = ((day - 1) ~/ 7) + 1;
//     //
//     //     weekMap[weekIndex] = weekMap[weekIndex] == null
//     //         ? log["value"]
//     //         : weekMap[weekIndex]! + log["value"];
//     //   }
//     //
//     //   int totalWeeks =
//     //       ((DateTime(DateTime.now().year, DateTime.now().month + 1, 0).day -
//     //               1) ~/
//     //           7) +
//     //       1;
//     //
//     //   return List.generate(totalWeeks, (i) {
//     //     int week = i + 1;
//     //     return weekMap[week] ?? 0;
//     //   });
//     // }
//
//     if (type == "Weekly") {
//       Map<int, double> weekMap = {};
//
//       for (var log in logs) {
//         DateTime date = log["date"];
//         int dayOfYear = int.parse(DateFormat("D").format(date));
//         int weekIndex = ((dayOfYear - 1) ~/ 7) + 1;
//
//         // Replace previous value for the same week
//         weekMap[weekIndex] = log["value"];
//       }
//
//       int totalWeeks =
//           ((DateTime(
//                     DateTime.now().year,
//                     12,
//                     31,
//                   ).difference(DateTime(DateTime.now().year, 1, 1)).inDays +
//                   1) ~/
//               7) +
//           1;
//
//       return List.generate(totalWeeks, (i) {
//         int week = i + 1;
//         return weekMap[week] ?? 0;
//       });
//     }
//
//     if (type == "Monthly") {
//       Map<int, double> monthMap = {};
//
//       for (var log in logs) {
//         int month = log["date"].month;
//
//         monthMap[month] = log["value"];
//       }
//
//       return List.generate(12, (i) {
//         int month = i + 1;
//         return monthMap[month] ?? 0;
//       });
//     }
//
//     return [];
//   }
//
//   Future<double?> getLatestLogValue(int id) async {
//     final db = await database;
//
//     final res = await db.query(
//       "custom_tracker_logs",
//       where: "tracker_id = ?",
//       whereArgs: [id],
//       //orderBy: "date DESC",
//       orderBy: "date(date) DESC",
//       limit: 1,
//     );
//
//     if (res.isEmpty) return null;
//     return (res.first["value"] as num).toDouble();
//   }
//
//   Future<int> insertOrUpdateCustomTrackerLog({
//     required int trackerId,
//     required String fieldName,
//     required double value,
//     required DateTime date,
//     required String type,
//   }) async {
//     final db = await instance.database;
//
//     DateTime startDate;
//     DateTime endDate;
//
//     if (type == "Daily") {
//       startDate = DateTime(date.year, date.month, date.day);
//       endDate = startDate.add(const Duration(days: 1));
//     } else if (type == "Weekly") {
//       int weekday = date.weekday; // 1=Mon, 7=Sun
//       startDate = date.subtract(Duration(days: weekday - 1)); // start of week
//       endDate = startDate.add(const Duration(days: 7));
//     } else if (type == "Monthly") {
//       startDate = DateTime(date.year, date.month, 1);
//       endDate = DateTime(date.year, date.month + 1, 1);
//     } else {
//       startDate = DateTime(date.year, date.month, date.day);
//       endDate = startDate.add(const Duration(days: 1));
//     }
//
//     final existing = await db.query(
//       "custom_tracker_logs",
//       where: "tracker_id = ? AND date >= ? AND date < ?",
//       whereArgs: [
//         trackerId,
//         startDate.toIso8601String(),
//         endDate.toIso8601String(),
//       ],
//     );
//
//     if (existing.isNotEmpty) {
//       // Update existing row
//       return await db.update(
//         "custom_tracker_logs",
//         {
//           "value": value,
//           "field_name": fieldName,
//           "date": date.toIso8601String(),
//         },
//         where: "tracker_id = ? AND date >= ? AND date < ?",
//         whereArgs: [
//           trackerId,
//           startDate.toIso8601String(),
//           endDate.toIso8601String(),
//         ],
//       );
//     } else {
//       return await db.insert("custom_tracker_logs", {
//         "tracker_id": trackerId,
//         "field_name": fieldName,
//         "value": value,
//         "date": date.toIso8601String(),
//       });
//     }
//   }
//
//   Future<double?> getLatestTrackerValue(int trackerId, String type) async {
//     final db = await database;
//
//     String queryOrder;
//
//     if (type == "Daily") {
//       queryOrder = "date DESC";
//     } else if (type == "Weekly") {
//       queryOrder = "date DESC";
//     } else if (type == "Monthly") {
//       queryOrder = "date DESC";
//     } else {
//       queryOrder = "date DESC";
//     }
//
//     final res = await db.query(
//       "custom_tracker_logs",
//       where: "tracker_id = ?",
//       whereArgs: [trackerId],
//       orderBy: queryOrder,
//       limit: 1,
//     );
//
//     if (res.isEmpty) return null;
//
//     return (res.first["value"] as num).toDouble();
//   }
// }

import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'database_model/excercise_history_data.dart';
import 'database_model/session_complete_data.dart';

class WeightDB {
  static final WeightDB instance = WeightDB._init();
  static Database? _database;

  WeightDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('weight_log.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createWorkoutSessionTables(db);
    }
    if (oldVersion < 3) {
      await _createSessionExerciseTables(db);
    }
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE weight_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kg REAL NOT NULL,
        lbs REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE custom_trackers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        unit TEXT NOT NULL,
        type TEXT NOT NULL,
        "values" TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE custom_tracker_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tracker_id INTEGER NOT NULL,
        field_name TEXT NOT NULL,
        value REAL NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY(tracker_id) REFERENCES custom_trackers(id)
      )
    ''');

    await _createWorkoutSessionTables(db);
  }

  Future _createWorkoutSessionTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS workout_sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workout_id INTEGER NOT NULL,
        workout_name TEXT NOT NULL,
        timer_seconds INTEGER NOT NULL DEFAULT 0,
        date TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        UNIQUE(workout_id, date)
      )
    ''');
  }

  Future _createSessionExerciseTables(Database db) async {
    // Table for exercises in a session
    await db.execute('''
      CREATE TABLE IF NOT EXISTS session_exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        exercise_id INTEGER NOT NULL,
        exercise_name TEXT NOT NULL,
        exercise_image_url TEXT,
        order_index INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY(session_id) REFERENCES workout_sessions(id) ON DELETE CASCADE
      )
    ''');

    // Table for sets within each exercise
    await db.execute('''
      CREATE TABLE IF NOT EXISTS session_exercise_sets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_exercise_id INTEGER NOT NULL,
        set_number INTEGER NOT NULL,
        weight REAL NOT NULL DEFAULT 0,
        reps INTEGER NOT NULL DEFAULT 0,
        is_completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY(session_exercise_id) REFERENCES session_exercises(id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better query performance
    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_session_exercises_session_id 
      ON session_exercises(session_id)
    ''');

    await db.execute('''
      CREATE INDEX IF NOT EXISTS idx_session_exercise_sets_session_exercise_id 
      ON session_exercise_sets(session_exercise_id)
    ''');
  }

  // ==================== SESSION EXERCISE METHODS ====================

  /// Save all exercises and their sets for a session
  Future<void> saveSessionExercises({
    required int sessionId,
    required List<SessionExerciseData> exercises,
  }) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();

    // Delete existing exercises for this session (in case of re-save)
    await db.delete(
      'session_exercises',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );

    // Insert each exercise and its sets
    for (int i = 0; i < exercises.length; i++) {
      final exercise = exercises[i];

      // Insert exercise
      final sessionExerciseId = await db.insert('session_exercises', {
        'session_id': sessionId,
        'exercise_id': exercise.exerciseId,
        'exercise_name': exercise.exerciseName,
        'exercise_image_url': exercise.imageUrl,
        'order_index': i,
        'created_at': now,
      });

      // Insert sets for this exercise
      for (final set in exercise.sets) {
        await db.insert('session_exercise_sets', {
          'session_exercise_id': sessionExerciseId,
          'set_number': set.setNumber,
          'weight': set.weight,
          'reps': set.reps,
          'is_completed': set.isCompleted ? 1 : 0,
          'created_at': now,
        });
      }
    }
  }

  /// Get exercise history by exercise ID
  Future<List<Map<String, dynamic>>> getExerciseHistoryById(
    int exerciseId,
  ) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
    SELECT 
      se.exercise_id,
      se.exercise_name,
      se.exercise_image_url,
      ws.date,
      ws.timer_seconds,
      ws.workout_name,
      ses.set_number,
      ses.weight,
      ses.reps,
      ses.is_completed
    FROM session_exercise_sets ses
    INNER JOIN session_exercises se ON ses.session_exercise_id = se.id
    INNER JOIN workout_sessions ws ON se.session_id = ws.id
    WHERE se.exercise_id = ? AND ses.is_completed = 1
    ORDER BY ws.date DESC, ses.set_number ASC
  ''',
      [exerciseId],
    );

    return result;
  }

  /// Get exercise history grouped by date
  Future<List<ExerciseHistoryData>> getExerciseHistoryGrouped(
    int exerciseId,
  ) async {
    final db = await database;

    // Get all sessions that include this exercise
    final sessions = await db.rawQuery(
      '''
    SELECT DISTINCT 
      ws.id as session_id,
      ws.date,
      ws.timer_seconds,
      ws.workout_name
    FROM workout_sessions ws
    INNER JOIN session_exercises se ON se.session_id = ws.id
    WHERE se.exercise_id = ? AND ws.is_completed = 1
    ORDER BY ws.date DESC
  ''',
      [exerciseId],
    );

    List<ExerciseHistoryData> result = [];

    for (final session in sessions) {
      // Get the session_exercise for this exercise in this session
      final sessionExercises = await db.query(
        'session_exercises',
        where: 'session_id = ? AND exercise_id = ?',
        whereArgs: [session['session_id'], exerciseId],
      );

      if (sessionExercises.isEmpty) continue;

      final sessionExerciseId = sessionExercises.first['id'] as int;

      // Get sets for this exercise
      final sets = await db.query(
        'session_exercise_sets',
        where: 'session_exercise_id = ? AND is_completed = 1',
        whereArgs: [sessionExerciseId],
        orderBy: 'set_number ASC',
      );

      if (sets.isEmpty) continue;

      result.add(
        ExerciseHistoryData(
          date: session['date'] as String,
          workoutName: session['workout_name'] as String,
          timerSeconds: session['timer_seconds'] as int,
          sets: sets
              .map(
                (s) => ExerciseSetRecord(
                  setNumber: s['set_number'] as int,
                  weight: (s['weight'] as num).toDouble(),
                  reps: s['reps'] as int,
                ),
              )
              .toList(),
        ),
      );
    }

    return result;
  }

  /// Complete session and save all exercise data
  Future<int> completeSessionWithExercises({
    required int sessionId,
    required List<SessionExerciseData> exercises,
  }) async {
    final db = await database;

    // Save exercises and sets
    await saveSessionExercises(sessionId: sessionId, exercises: exercises);

    // Mark session as completed
    return await db.update(
      'workout_sessions',
      {'is_completed': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  /// Get all exercises for a session
  Future<List<Map<String, dynamic>>> getSessionExercises(int sessionId) async {
    final db = await database;

    return await db.query(
      'session_exercises',
      where: 'session_id = ?',
      whereArgs: [sessionId],
      orderBy: 'order_index ASC',
    );
  }

  /// Get all sets for a session exercise
  Future<List<Map<String, dynamic>>> getSessionExerciseSets(
    int sessionExerciseId,
  ) async {
    final db = await database;

    return await db.query(
      'session_exercise_sets',
      where: 'session_exercise_id = ?',
      whereArgs: [sessionExerciseId],
      orderBy: 'set_number ASC',
    );
  }

  /// Get complete session data with exercises and sets
  Future<SessionCompleteData?> getCompleteSessionData(int sessionId) async {
    final db = await database;

    // Get session
    final sessions = await db.query(
      'workout_sessions',
      where: 'id = ?',
      whereArgs: [sessionId],
    );

    if (sessions.isEmpty) return null;

    final session = sessions.first;

    // Get exercises
    final exercisesData = await getSessionExercises(sessionId);
    List<SessionExerciseData> exercises = [];

    for (final exData in exercisesData) {
      final setsData = await getSessionExerciseSets(exData['id'] as int);

      final sets = setsData
          .map(
            (s) => SessionSetData(
              setNumber: s['set_number'] as int,
              weight: (s['weight'] as num).toDouble(),
              reps: s['reps'] as int,
              isCompleted: s['is_completed'] == 1,
            ),
          )
          .toList();

      exercises.add(
        SessionExerciseData(
          exerciseId: exData['exercise_id'] as int,
          exerciseName: exData['exercise_name'] as String,
          imageUrl: exData['exercise_image_url'] as String?,
          sets: sets,
        ),
      );
    }

    return SessionCompleteData(
      sessionId: sessionId,
      workoutId: session['workout_id'] as int,
      workoutName: session['workout_name'] as String,
      timerSeconds: session['timer_seconds'] as int,
      date: session['date'] as String,
      isCompleted: session['is_completed'] == 1,
      exercises: exercises,
    );
  }

  Future<List<SessionCompleteData>> getWorkoutHistoryWithDetails(
    int workoutId,
  ) async {
    final db = await database;

    final sessions = await db.query(
      'workout_sessions',
      where: 'workout_id = ? AND is_completed = 1',
      whereArgs: [workoutId],
      orderBy: 'date DESC',
    );

    List<SessionCompleteData> result = [];

    for (final session in sessions) {
      final data = await getCompleteSessionData(session['id'] as int);
      if (data != null) {
        result.add(data);
      }
    }

    return result;
  }

  /// Get total volume (weight × reps) for a session
  Future<double> getSessionTotalVolume(int sessionId) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
      SELECT SUM(ses.weight * ses.reps) as total_volume
      FROM session_exercise_sets ses
      INNER JOIN session_exercises se ON ses.session_exercise_id = se.id
      WHERE se.session_id = ? AND ses.is_completed = 1
    ''',
      [sessionId],
    );

    if (result.isNotEmpty && result.first['total_volume'] != null) {
      return (result.first['total_volume'] as num).toDouble();
    }
    return 0;
  }

  /// Get exercise statistics (best weight, total volume, etc.)
  Future<Map<String, dynamic>> getExerciseStats(int exerciseId) async {
    final db = await database;

    final result = await db.rawQuery(
      '''
      SELECT 
        MAX(ses.weight) as max_weight,
        MAX(ses.reps) as max_reps,
        SUM(ses.weight * ses.reps) as total_volume,
        COUNT(DISTINCT se.session_id) as session_count,
        AVG(ses.weight) as avg_weight,
        AVG(ses.reps) as avg_reps
      FROM session_exercise_sets ses
      INNER JOIN session_exercises se ON ses.session_exercise_id = se.id
      WHERE se.exercise_id = ? AND ses.is_completed = 1
    ''',
      [exerciseId],
    );

    if (result.isNotEmpty) {
      return {
        'max_weight': result.first['max_weight'] ?? 0,
        'max_reps': result.first['max_reps'] ?? 0,
        'total_volume': result.first['total_volume'] ?? 0,
        'session_count': result.first['session_count'] ?? 0,
        'avg_weight': result.first['avg_weight'] ?? 0,
        'avg_reps': result.first['avg_reps'] ?? 0,
      };
    }

    return {
      'max_weight': 0,
      'max_reps': 0,
      'total_volume': 0,
      'session_count': 0,
      'avg_weight': 0,
      'avg_reps': 0,
    };
  }

  /// Get personal records for an exercise
  Future<List<Map<String, dynamic>>> getExercisePersonalRecords(
    int exerciseId,
  ) async {
    final db = await database;

    return await db.rawQuery(
      '''
      SELECT 
        ses.weight,
        ses.reps,
        ws.date,
        ws.workout_name
      FROM session_exercise_sets ses
      INNER JOIN session_exercises se ON ses.session_exercise_id = se.id
      INNER JOIN workout_sessions ws ON se.session_id = ws.id
      WHERE se.exercise_id = ? AND ses.is_completed = 1
      ORDER BY ses.weight DESC
      LIMIT 10
    ''',
      [exerciseId],
    );
  }

  // ==================== WORKOUT SESSION METHODS (Timer Only) ====================

  String _getTodayDateString() {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
    ).toIso8601String().split('T')[0];
  }

  /// Get or create a workout session for today (timer persistence)
  Future<Map<String, dynamic>> getOrCreateTodaySession({
    required int workoutId,
    required String workoutName,
  }) async {
    final db = await database;
    final todayDate = _getTodayDateString();

    final existing = await db.query(
      'workout_sessions',
      where: 'workout_id = ? AND date = ?',
      whereArgs: [workoutId, todayDate],
    );

    if (existing.isNotEmpty) {
      return existing.first;
    }

    final now = DateTime.now().toIso8601String();
    final sessionId = await db.insert('workout_sessions', {
      'workout_id': workoutId,
      'workout_name': workoutName,
      'timer_seconds': 0,
      'date': todayDate,
      'is_completed': 0,
      'created_at': now,
      'updated_at': now,
    });

    return {
      'id': sessionId,
      'workout_id': workoutId,
      'workout_name': workoutName,
      'timer_seconds': 0,
      'date': todayDate,
      'is_completed': 0,
      'created_at': now,
      'updated_at': now,
    };
  }

  /// Update timer for a session
  Future<int> updateSessionTimer(int sessionId, int timerSeconds) async {
    final db = await database;
    return await db.update(
      'workout_sessions',
      {
        'timer_seconds': timerSeconds,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  /// Mark session as completed
  Future<int> completeSession(int sessionId) async {
    final db = await database;
    return await db.update(
      'workout_sessions',
      {'is_completed': 1, 'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [sessionId],
    );
  }

  /// Get workout history (all sessions for a workout)
  Future<List<Map<String, dynamic>>> getWorkoutHistory(int workoutId) async {
    final db = await database;
    return await db.query(
      'workout_sessions',
      where: 'workout_id = ?',
      whereArgs: [workoutId],
      orderBy: 'date DESC',
    );
  }

  /// Get all sessions for a date
  Future<List<Map<String, dynamic>>> getSessionsByDate(DateTime date) async {
    final db = await database;
    final dateString = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String().split('T')[0];

    return await db.query(
      'workout_sessions',
      where: 'date = ?',
      whereArgs: [dateString],
      orderBy: 'created_at DESC',
    );
  }

  /// Get today's sessions
  Future<List<Map<String, dynamic>>> getTodaySessions() async {
    return await getSessionsByDate(DateTime.now());
  }

  /// Delete old sessions (cleanup - optional)
  Future<int> deleteOldSessions(int daysToKeep) async {
    final db = await database;
    final cutoffDate = DateTime.now()
        .subtract(Duration(days: daysToKeep))
        .toIso8601String()
        .split('T')[0];

    return await db.delete(
      'workout_sessions',
      where: 'date < ? AND is_completed = 1',
      whereArgs: [cutoffDate],
    );
  }

  Future<int> getThisWeekWorkoutCount() async {
    final db = await database;

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    ).toIso8601String().split('T')[0];

    final result = await db.rawQuery(
      '''
    SELECT COUNT(*) as count
    FROM workout_sessions
    WHERE is_completed = 1 AND date >= ?
    ''',
      [startDate],
    );

    return (result.first['count'] as int?) ?? 0;
  }

  Future<int> getThisMonthWorkoutCount() async {
    final db = await database;

    final now = DateTime.now();
    final startDate = DateTime(
      now.year,
      now.month,
      1,
    ).toIso8601String().split('T')[0];

    final result = await db.rawQuery(
      '''
    SELECT COUNT(*) as count
    FROM workout_sessions
    WHERE is_completed = 1 AND date >= ?
    ''',
      [startDate],
    );

    return (result.first['count'] as int?) ?? 0;
  }

  Future<double> getAverageWeeklyWorkouts() async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT AVG(weekly_count) as avg_weekly
    FROM (
      SELECT strftime('%Y-%W', date) as week,
             COUNT(*) as weekly_count
      FROM workout_sessions
      WHERE is_completed = 1
      GROUP BY week
    )
  ''');

    final value = result.first['avg_weekly'];
    return value == null ? 0 : (value as num).toDouble();
  }

  Future<double> getAverageMonthlyWorkouts() async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT AVG(monthly_count) as avg_monthly
    FROM (
      SELECT strftime('%Y-%m', date) as month,
             COUNT(*) as monthly_count
      FROM workout_sessions
      WHERE is_completed = 1
      GROUP BY month
    )
  ''');

    final value = result.first['avg_monthly'];
    return value == null ? 0 : (value as num).toDouble();
  }

  Future<int> getTotalWorkoutCount() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM workout_sessions WHERE is_completed = 1',
    );

    return (result.first['count'] as int?) ?? 0;
  }

  // ==================== WORKOUT TIME STATISTICS ====================

  /// Get total time for all workouts ever
  Future<int> getTotalWorkoutTime() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT SUM(timer_seconds) as total FROM workout_sessions WHERE is_completed = 1',
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    }
    return 0;
  }

  /// Get total time for a specific workout (by workout_id)
  Future<int> getTotalTimeForWorkout(int workoutId) async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT SUM(timer_seconds) as total FROM workout_sessions WHERE workout_id = ? AND is_completed = 1',
      [workoutId],
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    }
    return 0;
  }

  /// Get total time for today
  Future<int> getTodayTotalTime() async {
    final db = await database;
    final todayDate = _getTodayDateString();

    final result = await db.rawQuery(
      'SELECT SUM(timer_seconds) as total FROM workout_sessions WHERE date = ?',
      [todayDate],
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    }
    return 0;
  }

  Future<List<int>> getCurrentWeekDailyWorkoutTime() async {
    final db = await database;

    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day - (now.weekday - 1),
    );

    final startDate = startOfWeek.toIso8601String().split('T')[0];

    final result = await db.rawQuery(
      '''
    SELECT date, SUM(timer_seconds) as total_seconds
    FROM workout_sessions
    WHERE is_completed = 1 AND date >= ?
    GROUP BY date
  ''',
      [startDate],
    );

    /// Map date -> total seconds
    final Map<String, int> dayMap = {};
    for (var row in result) {
      dayMap[row['date'] as String] = (row['total_seconds'] as num).toInt();
    }

    /// Create 7-day list (Mon → Sun)
    return List.generate(7, (index) {
      final day = startOfWeek.add(Duration(days: index));
      final key = day.toIso8601String().split('T')[0];
      return dayMap[key] ?? 0;
    });
  }

  Future<List<int>> getCurrentMonthDailyWorkoutTime() async {
    final db = await database;

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);

    final startDate = startOfMonth.toIso8601String().split('T')[0];
    final endDate = endOfMonth.toIso8601String().split('T')[0];

    final result = await db.rawQuery(
      '''
    SELECT date, SUM(timer_seconds) as total_seconds
    FROM workout_sessions
    WHERE is_completed = 1
      AND date >= ?
      AND date < ?
    GROUP BY date
  ''',
      [startDate, endDate],
    );

    /// Map date -> total seconds
    final Map<String, int> dayMap = {};
    for (var row in result) {
      dayMap[row['date'] as String] = (row['total_seconds'] as num).toInt();
    }

    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    /// Build list for entire month
    return List.generate(daysInMonth, (index) {
      final dayDate = DateTime(now.year, now.month, index + 1);
      final key = dayDate.toIso8601String().split('T')[0];
      return dayMap[key] ?? 0;
    });
  }

  /// Get total time for this week
  Future<int> getThisWeekTotalTime() async {
    final db = await database;

    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    ).toIso8601String().split('T')[0];

    final result = await db.rawQuery(
      'SELECT SUM(timer_seconds) as total FROM workout_sessions WHERE date >= ? AND is_completed = 1',
      [startDate],
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    }
    return 0;
  }

  /// Get total time for this month
  Future<int> getThisMonthTotalTime() async {
    final db = await database;

    final now = DateTime.now();
    final startDate = DateTime(
      now.year,
      now.month,
      1,
    ).toIso8601String().split('T')[0];

    final result = await db.rawQuery(
      'SELECT SUM(timer_seconds) as total FROM workout_sessions WHERE date >= ? AND is_completed = 1',
      [startDate],
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as int;
    }
    return 0;
  }

  /// Get workout time statistics summary
  Future<Map<String, dynamic>> getWorkoutTimeStats() async {
    final db = await database;

    final totalResult = await db.rawQuery(
      'SELECT SUM(timer_seconds) as total, COUNT(*) as count, AVG(timer_seconds) as avg FROM workout_sessions WHERE is_completed = 1',
    );

    final todayTime = await getTodayTotalTime();
    final weekTime = await getThisWeekTotalTime();
    final monthTime = await getThisMonthTotalTime();

    final longestResult = await db.rawQuery(
      'SELECT MAX(timer_seconds) as longest FROM workout_sessions WHERE is_completed = 1',
    );

    return {
      'total_seconds': totalResult.first['total'] ?? 0,
      'total_workouts': totalResult.first['count'] ?? 0,
      'average_seconds': (totalResult.first['avg'] as num?)?.toInt() ?? 0,
      'today_seconds': todayTime,
      'week_seconds': weekTime,
      'month_seconds': monthTime,
      'longest_workout_seconds': longestResult.first['longest'] ?? 0,
    };
  }

  /// Get time per workout type/name
  Future<List<Map<String, dynamic>>> getTimeByWorkoutName() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT workout_name, 
             workout_id,
             SUM(timer_seconds) as total_seconds, 
             COUNT(*) as workout_count,
             AVG(timer_seconds) as avg_seconds
      FROM workout_sessions 
      WHERE is_completed = 1
      GROUP BY workout_id, workout_name
      ORDER BY total_seconds DESC
    ''');

    return result;
  }

  /// Get workout streak (consecutive days)
  Future<int> getCurrentStreak() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT DISTINCT date FROM workout_sessions 
      WHERE is_completed = 1 
      ORDER BY date DESC
    ''');

    if (result.isEmpty) return 0;

    int streak = 0;
    DateTime? previousDate;

    for (var row in result) {
      final dateStr = row['date'] as String;
      final currentDate = DateTime.parse(dateStr);

      if (previousDate == null) {
        final today = DateTime.now();
        final todayOnly = DateTime(today.year, today.month, today.day);
        final yesterday = todayOnly.subtract(const Duration(days: 1));

        if (currentDate == todayOnly || currentDate == yesterday) {
          streak = 1;
          previousDate = currentDate;
        } else {
          break;
        }
      } else {
        final expectedDate = previousDate.subtract(const Duration(days: 1));
        if (currentDate == expectedDate) {
          streak++;
          previousDate = currentDate;
        } else {
          break;
        }
      }
    }

    return streak;
  }

  Future<int> getLongestStreak() async {
    final db = await database;

    final result = await db.rawQuery('''
      SELECT DISTINCT date FROM workout_sessions 
      WHERE is_completed = 1 
      ORDER BY date ASC
    ''');

    if (result.isEmpty) return 0;

    int longestStreak = 1;
    int currentStreak = 1;
    DateTime? previousDate;

    for (var row in result) {
      final dateStr = row['date'] as String;
      final currentDate = DateTime.parse(dateStr);

      if (previousDate != null) {
        final expectedDate = previousDate.add(const Duration(days: 1));
        if (currentDate == expectedDate) {
          currentStreak++;
          if (currentStreak > longestStreak) {
            longestStreak = currentStreak;
          }
        } else {
          currentStreak = 1;
        }
      }
      previousDate = currentDate;
    }

    return longestStreak;
  }

  Future<Map<String, Map<String, String>>> getLatestThreeHistory() async {
    final db = await database;

    final result = await db.rawQuery('''
    SELECT date, SUM(timer_seconds) as total
    FROM workout_sessions
    WHERE is_completed = 1
    GROUP BY date
    ORDER BY date DESC
    LIMIT 3
  ''');

    final Map<String, Map<String, String>> history = {};

    for (var row in result) {
      history[row['date'] as String] = {
        "totalTime": "${(row['total'] as int) ~/ 60} mins",
      };
    }

    return history;
  }

  // ==================== EXISTING WEIGHT/TRACKER METHODS ====================

  Future<int> insertWeight(double value, String unit, DateTime date) async {
    final db = await instance.database;

    double kg;
    double lbs;

    if (unit == "kg") {
      kg = value;
      lbs = value * 2.20462;
    } else {
      lbs = value;
      kg = value / 2.20462;
    }

    return await db.insert('weight_logs', {
      'kg': double.parse(kg.toStringAsFixed(1)),
      'lbs': double.parse(lbs.toStringAsFixed(1)),
      'date': DateTime(date.year, date.month, date.day).toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getMonthWeights(
    int year,
    int month,
  ) async {
    final db = await database;

    String start = DateTime(year, month, 1).toIso8601String();
    String end = DateTime(year, month + 1, 1).toIso8601String();

    return await db.query(
      "weight_logs",
      where: "date >= ? AND date < ?",
      whereArgs: [start, end],
    );
  }

  Future<Map<String, dynamic>?> getByDate(DateTime date) async {
    final db = await instance.database;
    final formattedDate = DateTime(
      date.year,
      date.month,
      date.day,
    ).toIso8601String();

    final res = await db.query(
      'weight_logs',
      where: "date LIKE ?",
      whereArgs: ["$formattedDate%"],
      limit: 1,
    );

    if (res.isNotEmpty) return res.first;
    return null;
  }

  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await instance.database;
    return await db.query('weight_logs', orderBy: "date DESC");
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('weight_logs', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getLatestWeight() async {
    final db = await database;
    final result = await db.query('weight_logs', orderBy: 'id DESC', limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> insertTracker(
    String name,
    String unit,
    String type,
    List<double> values,
  ) async {
    final db = await instance.database;
    return db.insert('custom_trackers', {
      'name': name,
      'unit': unit,
      'type': type,
      'values': values.toString(),
    });
  }

  Future<List<Map<String, dynamic>>> getAllTrackers() async {
    final db = await instance.database;
    return await db.query("custom_trackers");
  }

  Future<int> deleteTracker(int id) async {
    final db = await instance.database;
    return await db.delete('custom_trackers', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertCustomTrackerLog({
    required int trackerId,
    required String fieldName,
    required double value,
    required DateTime date,
  }) async {
    final db = await instance.database;

    return await db.insert("custom_tracker_logs", {
      "tracker_id": trackerId,
      "field_name": fieldName,
      "value": value,
      "date": DateTime(date.year, date.month, date.day).toIso8601String(),
    });
  }

  Future<List<double>> getTrackerLogs(int trackerId, String type) async {
    final db = await instance.database;

    final res = await db.query(
      "custom_tracker_logs",
      where: "tracker_id = ?",
      whereArgs: [trackerId],
      orderBy: "date ASC",
    );

    List<Map<String, dynamic>> logs = res.map((row) {
      return {
        "value": (row["value"] as num).toDouble(),
        "date": DateTime.parse(row["date"] as String),
      };
    }).toList();

    if (type == "Daily") {
      Map<int, double> dailyMap = {};
      for (var log in logs) {
        int day = log["date"].day;
        dailyMap[day] = log["value"];
      }

      final now = DateTime.now();
      final year = now.year;
      final month = now.month;
      final lastDayOfMonth = DateTime(year, month + 1, 0).day;

      return List.generate(lastDayOfMonth, (i) {
        int day = i + 1;
        return dailyMap[day] ?? 0;
      });
    }

    if (type == "Weekly") {
      Map<int, double> weekMap = {};
      for (var log in logs) {
        DateTime date = log["date"];
        int dayOfYear = int.parse(DateFormat("D").format(date));
        int weekIndex = ((dayOfYear - 1) ~/ 7) + 1;
        weekMap[weekIndex] = log["value"];
      }

      int totalWeeks =
          ((DateTime(
                    DateTime.now().year,
                    12,
                    31,
                  ).difference(DateTime(DateTime.now().year, 1, 1)).inDays +
                  1) ~/
              7) +
          1;

      return List.generate(totalWeeks, (i) {
        int week = i + 1;
        return weekMap[week] ?? 0;
      });
    }

    if (type == "Monthly") {
      Map<int, double> monthMap = {};
      for (var log in logs) {
        int month = log["date"].month;
        monthMap[month] = log["value"];
      }

      return List.generate(12, (i) {
        int month = i + 1;
        return monthMap[month] ?? 0;
      });
    }

    return [];
  }

  Future<double?> getLatestLogValue(int id) async {
    final db = await database;

    final res = await db.query(
      "custom_tracker_logs",
      where: "tracker_id = ?",
      whereArgs: [id],
      orderBy: "date(date) DESC",
      limit: 1,
    );

    if (res.isEmpty) return null;
    return (res.first["value"] as num).toDouble();
  }

  Future<int> insertOrUpdateCustomTrackerLog({
    required int trackerId,
    required String fieldName,
    required double value,
    required DateTime date,
    required String type,
  }) async {
    final db = await instance.database;

    DateTime startDate;
    DateTime endDate;

    if (type == "Daily") {
      startDate = DateTime(date.year, date.month, date.day);
      endDate = startDate.add(const Duration(days: 1));
    } else if (type == "Weekly") {
      int weekday = date.weekday;
      startDate = date.subtract(Duration(days: weekday - 1));
      endDate = startDate.add(const Duration(days: 7));
    } else if (type == "Monthly") {
      startDate = DateTime(date.year, date.month, 1);
      endDate = DateTime(date.year, date.month + 1, 1);
    } else {
      startDate = DateTime(date.year, date.month, date.day);
      endDate = startDate.add(const Duration(days: 1));
    }

    final existing = await db.query(
      "custom_tracker_logs",
      where: "tracker_id = ? AND date >= ? AND date < ?",
      whereArgs: [
        trackerId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
    );

    if (existing.isNotEmpty) {
      return await db.update(
        "custom_tracker_logs",
        {
          "value": value,
          "field_name": fieldName,
          "date": date.toIso8601String(),
        },
        where: "tracker_id = ? AND date >= ? AND date < ?",
        whereArgs: [
          trackerId,
          startDate.toIso8601String(),
          endDate.toIso8601String(),
        ],
      );
    } else {
      return await db.insert("custom_tracker_logs", {
        "tracker_id": trackerId,
        "field_name": fieldName,
        "value": value,
        "date": date.toIso8601String(),
      });
    }
  }

  Future<double?> getLatestTrackerValue(int trackerId, String type) async {
    final db = await database;

    final res = await db.query(
      "custom_tracker_logs",
      where: "tracker_id = ?",
      whereArgs: [trackerId],
      orderBy: "date DESC",
      limit: 1,
    );

    if (res.isEmpty) return null;
    return (res.first["value"] as num).toDouble();
  }
}
