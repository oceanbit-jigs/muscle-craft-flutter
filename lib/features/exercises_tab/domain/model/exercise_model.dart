import 'dart:io';

class ExerciseResponseModel {
  final bool status;
  final String message;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;
  final List<ExerciseModel> data;

  ExerciseResponseModel({
    required this.status,
    required this.message,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.data,
  });

  factory ExerciseResponseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseResponseModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
      data: List<ExerciseModel>.from(
        (json['data'] ?? []).map((e) => ExerciseModel.fromJson(e)),
      ),
    );
  }
}

class ExerciseModel {
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
  final List<EquipmentModel> equipments;
  final List<FocusAreaModel> focusAreas;
  File? thumbnail;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
    required this.maleVideoPath,
    required this.femaleVideoPath,
    required this.preparationText,
    required this.executionPoint,
    required this.keyTips,
    required this.equipments,
    required this.focusAreas,
    this.description,
    this.thumbnail,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      maleVideoPath: json['male_video_path'] ?? '',
      femaleVideoPath: json['female_video_path'] ?? '',
      preparationText: json['preparation_text'] ?? '',
      executionPoint: json['execution_point'] ?? '',
      keyTips: json['key_tips'] ?? '',
      description: json['description'],
      equipments: List<EquipmentModel>.from(
        (json['equipments'] ?? []).map((e) => EquipmentModel.fromJson(e)),
      ),
      focusAreas: List<FocusAreaModel>.from(
        (json['focus_areas'] ?? []).map((e) => FocusAreaModel.fromJson(e)),
      ),
    );
  }
}

class EquipmentModel {
  final int id;
  final String name;
  final String displayName;
  final String imageUrl;

  EquipmentModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}

class FocusAreaModel {
  final int id;
  final String name;
  final String displayName;
  final String imageUrl;

  FocusAreaModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
  });

  factory FocusAreaModel.fromJson(Map<String, dynamic> json) {
    return FocusAreaModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      displayName: json['display_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
