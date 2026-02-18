class UpdateUserDetailsModel {
  final bool status;
  final String message;
  final UpdateUserDetailsData data;

  UpdateUserDetailsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UpdateUserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UpdateUserDetailsModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: UpdateUserDetailsData.fromJson(json['data'] ?? {}),
    );
  }
}

class UpdateUserDetailsData {
  final UserDetail userDetail;
  final List<int> goals;
  final List<int> focusAreas;

  UpdateUserDetailsData({
    required this.userDetail,
    required this.goals,
    required this.focusAreas,
  });

  factory UpdateUserDetailsData.fromJson(Map<String, dynamic> json) {
    return UpdateUserDetailsData(
      userDetail: UserDetail.fromJson(json['user_detail'] ?? {}),
      goals: List<int>.from(json['goals'] ?? []),
      focusAreas: List<int>.from(json['focus_areas'] ?? []),
    );
  }
}

class UserDetail {
  final int id;
  final int userId;
  final String gender;
  final String userName;
  final int age;
  final String currentWeightType;
  final double currentWeight;
  final String targetWeightType;
  final double targetWeight;
  final String heightType;
  final double height;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserDetail({
    required this.id,
    required this.userId,
    required this.gender,
    required this.userName,
    required this.age,
    required this.currentWeightType,
    required this.currentWeight,
    required this.targetWeightType,
    required this.targetWeight,
    required this.heightType,
    required this.height,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      gender: json['gender'] ?? '',
      userName: json['user_name'] ?? '',
      age: int.tryParse(json['age'].toString()) ?? 0,

      currentWeightType: json['current_weight_type'] ?? '',
      currentWeight: double.tryParse(json['current_weight'].toString()) ?? 0.0,

      targetWeightType: json['target_weight_type'] ?? '',
      targetWeight: double.tryParse(json['target_weight'].toString()) ?? 0.0,

      heightType: json['height_type'] ?? '',
      height: double.tryParse(json['height'].toString()) ?? 0.0,

      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
