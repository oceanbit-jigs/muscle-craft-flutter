/// Data class for a single set
class SessionSetData {
  final int setNumber;
  final double weight;
  final int reps;
  final bool isCompleted;

  SessionSetData({
    required this.setNumber,
    required this.weight,
    required this.reps,
    required this.isCompleted,
  });

  Map<String, dynamic> toMap() {
    return {
      'set_number': setNumber,
      'weight': weight,
      'reps': reps,
      'is_completed': isCompleted,
    };
  }

  factory SessionSetData.fromMap(Map<String, dynamic> map) {
    return SessionSetData(
      setNumber: map['set_number'] as int,
      weight: (map['weight'] as num).toDouble(),
      reps: map['reps'] as int,
      isCompleted: map['is_completed'] == 1,
    );
  }
}

/// Data class for an exercise with its sets
class SessionExerciseData {
  final int exerciseId;
  final String exerciseName;
  final String? imageUrl;
  final List<SessionSetData> sets;

  SessionExerciseData({
    required this.exerciseId,
    required this.exerciseName,
    this.imageUrl,
    required this.sets,
  });

  int get completedSets => sets.where((s) => s.isCompleted).length;
  int get totalSets => sets.length;

  double get totalVolume {
    return sets
        .where((s) => s.isCompleted)
        .fold(0.0, (sum, s) => sum + (s.weight * s.reps));
  }

  Map<String, dynamic> toMap() {
    return {
      'exercise_id': exerciseId,
      'exercise_name': exerciseName,
      'image_url': imageUrl,
      'sets': sets.map((s) => s.toMap()).toList(),
    };
  }
}

/// Complete session data with all exercises
class SessionCompleteData {
  final int sessionId;
  final int workoutId;
  final String workoutName;
  final int timerSeconds;
  final String date;
  final bool isCompleted;
  final List<SessionExerciseData> exercises;

  SessionCompleteData({
    required this.sessionId,
    required this.workoutId,
    required this.workoutName,
    required this.timerSeconds,
    required this.date,
    required this.isCompleted,
    required this.exercises,
  });

  double get totalVolume {
    return exercises.fold(0.0, (sum, ex) => sum + ex.totalVolume);
  }

  int get totalCompletedSets {
    return exercises.fold(0, (sum, ex) => sum + ex.completedSets);
  }

  int get totalSets {
    return exercises.fold(0, (sum, ex) => sum + ex.totalSets);
  }
}
