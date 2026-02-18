class ExerciseHistoryData {
  final String date;
  final String workoutName;
  final int timerSeconds;
  final List<ExerciseSetRecord> sets;

  ExerciseHistoryData({
    required this.date,
    required this.workoutName,
    required this.timerSeconds,
    required this.sets,
  });

  double get totalVolume {
    return sets.fold(0.0, (sum, set) => sum + (set.weight * set.reps));
  }

  double get maxWeight {
    if (sets.isEmpty) return 0;
    return sets.map((s) => s.weight).reduce((a, b) => a > b ? a : b);
  }
}

class ExerciseSetRecord {
  final int setNumber;
  final double weight;
  final int reps;

  ExerciseSetRecord({
    required this.setNumber,
    required this.weight,
    required this.reps,
  });
}
