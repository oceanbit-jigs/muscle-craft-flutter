class CategoryModel {
  final bool status;
  final String message;
  final CategoryData data;

  CategoryModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: CategoryData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data.toJson()};
  }
}

class CategoryData {
  final int id;
  final String name;
  final String displayName;
  final String createdAt;
  final String updatedAt;
  final List<Workout> workouts;

  CategoryData({
    required this.id,
    required this.name,
    required this.displayName,
    required this.createdAt,
    required this.updatedAt,
    required this.workouts,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      workouts: (json['workouts'] as List<dynamic>)
          .map((e) => Workout.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'created_at': createdAt,
      'updated_at': updatedAt,
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
  final String createdAt;
  final String updatedAt;
  final Pivot pivot;

  Workout({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
    required this.isPopular,
    required this.kcalBurn,
    required this.timeInMin,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isPopular: json['is_popular'] ?? 0,
      kcalBurn: json['kcal_burn'] ?? "",
      timeInMin: json['time_in_min'] ?? 0,
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
      'is_popular': isPopular,
      'kcal_burn': kcalBurn,
      'time_in_min': timeInMin,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pivot': pivot.toJson(),
    };
  }
}

class Pivot {
  final int categoryId;
  final int workoutId;
  final int id;

  Pivot({required this.categoryId, required this.workoutId, required this.id});

  factory Pivot.fromJson(Map<String, dynamic> json) {
    return Pivot(
      categoryId: json['category_id'] ?? 0,
      workoutId: json['workout_id'] ?? 0,
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'category_id': categoryId, 'workout_id': workoutId, 'id': id};
  }
}
