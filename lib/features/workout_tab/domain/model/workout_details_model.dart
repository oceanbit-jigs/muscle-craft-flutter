class WorkoutDetailResponse {
  final bool status;
  final String message;
  final WorkoutData data;

  WorkoutDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WorkoutDetailResponse.fromJson(Map<String, dynamic> json) {
    return WorkoutDetailResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: WorkoutData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data.toJson()};
  }
}

class WorkoutData {
  final int id;
  final String name;
  final String displayName;
  final String imageUrl;
  final int isPopular;
  final String kcalBurn;
  final int timeInMin;
  final String createdAt;
  final String updatedAt;
  final List<WorkoutExercise> exercises;

  WorkoutData({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
    required this.isPopular,
    required this.kcalBurn,
    required this.timeInMin,
    required this.createdAt,
    required this.updatedAt,
    required this.exercises,
  });

  factory WorkoutData.fromJson(Map<String, dynamic> json) {
    return WorkoutData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isPopular: json['is_popular'] ?? 0,
      kcalBurn: json['kcal_burn'] ?? '',
      timeInMin: json['time_in_min'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      exercises: List<WorkoutExercise>.from(
        (json['exercises'] ?? []).map((x) => WorkoutExercise.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'image_url': imageUrl,
      'is_popular': isPopular,
      'kcal_burn': kcalBurn,
      'time_in_min': timeInMin,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkoutExercise {
  final int id;
  final String name;
  final String displayName;
  final String imageUrl;
  final String maleVideoPath;
  final String femaleVideoPath;
  final String preparationText;
  final String executionPoint;
  final String keyTips;
  final String? description;
  final String createdAt;
  final String updatedAt;
  final Pivot pivot;

  WorkoutExercise({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
    required this.maleVideoPath,
    required this.femaleVideoPath,
    required this.preparationText,
    required this.executionPoint,
    required this.keyTips,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
    this.description,
  });

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      maleVideoPath: json['male_video_path'] ?? '',
      femaleVideoPath: json['female_video_path'] ?? '',
      preparationText: json['preparation_text'] ?? '',
      executionPoint: json['execution_point'] ?? '',
      keyTips: json['key_tips'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      pivot: Pivot.fromJson(json['pivot']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'image_url': imageUrl,
      'male_video_path': maleVideoPath,
      'female_video_path': femaleVideoPath,
      'preparation_text': preparationText,
      'execution_point': executionPoint,
      'key_tips': keyTips,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pivot': pivot.toJson(),
    };
  }
}

class Pivot {
  final int workoutId;
  final int exerciseId;
  final int id;

  Pivot({required this.workoutId, required this.exerciseId, required this.id});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      workoutId: json['workout_id'] ?? 0,
      exerciseId: json['exercise_id'] ?? 0,
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'workout_id': workoutId, 'exercise_id': exerciseId, 'id': id};
  }
}
