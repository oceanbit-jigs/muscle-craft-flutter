class ExerciseSessionModel {
  final int? id;
  final int workoutSessionId;
  final int exerciseId;
  final String exerciseName;
  final String imageUrl;
  final int totalSets;
  final int completedSets;
  final String weightsJson; // Store as JSON string
  final String repsJson; // Store as JSON string
  final bool isCompleted;
  final String createdAt;
  final String updatedAt;

  ExerciseSessionModel({
    this.id,
    required this.workoutSessionId,
    required this.exerciseId,
    required this.exerciseName,
    required this.imageUrl,
    required this.totalSets,
    required this.completedSets,
    required this.weightsJson,
    required this.repsJson,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workout_session_id': workoutSessionId,
      'exercise_id': exerciseId,
      'exercise_name': exerciseName,
      'image_url': imageUrl,
      'total_sets': totalSets,
      'completed_sets': completedSets,
      'weights_json': weightsJson,
      'reps_json': repsJson,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  factory ExerciseSessionModel.fromMap(Map<String, dynamic> map) {
    return ExerciseSessionModel(
      id: map['id'],
      workoutSessionId: map['workout_session_id'],
      exerciseId: map['exercise_id'],
      exerciseName: map['exercise_name'],
      imageUrl: map['image_url'],
      totalSets: map['total_sets'],
      completedSets: map['completed_sets'],
      weightsJson: map['weights_json'],
      repsJson: map['reps_json'],
      isCompleted: map['is_completed'] == 1,
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  ExerciseSessionModel copyWith({
    int? id,
    int? workoutSessionId,
    int? exerciseId,
    String? exerciseName,
    String? imageUrl,
    int? totalSets,
    int? completedSets,
    String? weightsJson,
    String? repsJson,
    bool? isCompleted,
    String? createdAt,
    String? updatedAt,
  }) {
    return ExerciseSessionModel(
      id: id ?? this.id,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      imageUrl: imageUrl ?? this.imageUrl,
      totalSets: totalSets ?? this.totalSets,
      completedSets: completedSets ?? this.completedSets,
      weightsJson: weightsJson ?? this.weightsJson,
      repsJson: repsJson ?? this.repsJson,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
