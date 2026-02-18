// workout_exercise_details_response.dart
class WorkoutExerciseDetailsResponse {
  final bool status;
  final String message;
  final WorkoutExerciseDetails data;

  WorkoutExerciseDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory WorkoutExerciseDetailsResponse.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseDetailsResponse(
      status: json['status'],
      message: json['message'],
      data: WorkoutExerciseDetails.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}

class WorkoutExerciseDetails {
  final int id;
  final String name;
  final String displayName;
  final String? imageUrl;
  final String maleVideoPath;
  final String femaleVideoPath;
  final String preparationText;
  final String executionPoint;
  final String keyTips;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Equipment> equipments;
  final List<FocusArea> focusAreas;

  WorkoutExerciseDetails({
    required this.id,
    required this.name,
    required this.displayName,
    this.imageUrl,
    required this.maleVideoPath,
    required this.femaleVideoPath,
    required this.preparationText,
    required this.executionPoint,
    required this.keyTips,
    required this.createdAt,
    required this.updatedAt,
    required this.equipments,
    required this.focusAreas,
  });

  factory WorkoutExerciseDetails.fromJson(Map<String, dynamic> json) {
    return WorkoutExerciseDetails(
      id: json['id'],
      name: json['name'],
      displayName: json['display_name'],
      imageUrl: json['image_url'],
      maleVideoPath: json['male_video_path'],
      femaleVideoPath: json['female_video_path'],
      preparationText: json['preparation_text'],
      executionPoint: json['execution_point'],
      keyTips: json['key_tips'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      equipments: (json['equipments'] as List<dynamic>)
          .map((e) => Equipment.fromJson(e))
          .toList(),
      focusAreas: (json['focus_areas'] as List<dynamic>)
          .map((e) => FocusArea.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'display_name': displayName,
    'image_url': imageUrl,
    'male_video_path': maleVideoPath,
    'female_video_path': femaleVideoPath,
    'preparation_text': preparationText,
    'execution_point': executionPoint,
    'key_tips': keyTips,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'equipments': equipments.map((e) => e.toJson()).toList(),
    'focus_areas': focusAreas.map((e) => e.toJson()).toList(),
  };
}

class Equipment {
  final int id;
  final String name;
  final String displayName;
  final String imageUrl;

  Equipment({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'],
      name: json['name'],
      displayName: json['display_name'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'display_name': displayName,
    'image_url': imageUrl,
  };
}

class FocusArea {
  final int id;
  final String name;
  final String displayName;
  final String imageUrl;

  FocusArea({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
  });

  factory FocusArea.fromJson(Map<String, dynamic> json) {
    return FocusArea(
      id: json['id'],
      name: json['name'],
      displayName: json['display_name'],
      imageUrl: json['image_url'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'display_name': displayName,
    'image_url': imageUrl,
  };
}
