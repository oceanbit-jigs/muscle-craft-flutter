class DashboardResponse {
  final bool status;
  final String message;
  final DashboardData data;

  DashboardResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      status: json['status'],
      message: json['message'],
      data: DashboardData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data.toJson()};
  }
}

class DashboardData {
  final List<FocusArea> focusAreas;
  final List<Category> categories;

  DashboardData({required this.focusAreas, required this.categories});

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      focusAreas: (json['focus_areas'] as List)
          .map((e) => FocusArea.fromJson(e))
          .toList(),
      categories: (json['categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'focus_areas': focusAreas.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}

class FocusArea {
  final int id;
  final String name;
  final String displayName;
  final String? imageUrl;
  final String createdAt;
  final String updatedAt;

  FocusArea({
    required this.id,
    required this.name,
    required this.displayName,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FocusArea.fromJson(Map<String, dynamic> json) {
    return FocusArea(
      id: json['id'],
      name: json['name'],
      displayName: json['display_name'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'image_url': imageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Category {
  final int id;
  final String name;
  final String displayName;
  final List<Workout> workouts;

  Category({
    required this.id,
    required this.name,
    required this.displayName,
    required this.workouts,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      displayName: json['display_name'],
      workouts: (json['workouts'] as List)
          .map((e) => Workout.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'workouts': workouts.map((e) => e.toJson()).toList(),
    };
  }
}

class Workout {
  final int id;
  final String name;
  final String displayName;
  final String imageUrl;
  final int isPopular;
  final String kcalBurn;
  final int timeInMin;
  final List<Exercise> exercises;

  Workout({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
    required this.isPopular,
    required this.kcalBurn,
    required this.timeInMin,
    required this.exercises,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      displayName: json['display_name'],
      imageUrl: json['image_url'],
      isPopular: json['is_popular'],
      kcalBurn: json['kcal_burn'],
      timeInMin: json['time_in_min'],
      exercises: (json['exercises'] as List)
          .map((e) => Exercise.fromJson(e))
          .toList(),
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
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}

class Exercise {
  final int id;
  final String name;
  final String displayName;
  final String? imageUrl;
  final String maleVideoPath;
  final String femaleVideoPath;
  final String preparationText;
  final String executionPoint;
  final String keyTips;

  Exercise({
    required this.id,
    required this.name,
    required this.displayName,
    this.imageUrl,
    required this.maleVideoPath,
    required this.femaleVideoPath,
    required this.preparationText,
    required this.executionPoint,
    required this.keyTips,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      displayName: json['display_name'],
      imageUrl: json['image_url'],
      maleVideoPath: json['male_video_path'],
      femaleVideoPath: json['female_video_path'],
      preparationText: json['preparation_text'],
      executionPoint: json['execution_point'],
      keyTips: json['key_tips'],
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
    };
  }
}
