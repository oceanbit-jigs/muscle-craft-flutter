class UserDetailResponse {
  final bool status;
  final String message;
  final UserData data;

  UserDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserDetailResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailResponse(
      status: json['status'],
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
  };
}

class UserData {
  final User user;
  final UserDetail userDetail;
  final List<int> goals;
  final List<int> focusAreas;

  UserData({
    required this.user,
    required this.userDetail,
    required this.goals,
    required this.focusAreas,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: User.fromJson(json['user']),
      userDetail: UserDetail.fromJson(json['user_detail']),
      goals: List<int>.from(json['goals']),
      focusAreas: List<int>.from(json['focus_areas']),
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user.toJson(),
    'user_detail': userDetail.toJson(),
    'goals': goals,
    'focus_areas': focusAreas,
  };
}

class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? imageUrl;
  final String? fcmToken;
  final String? emailVerifiedAt;
  final int isAdmin;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final bool isNotificationEnable;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.imageUrl,
    this.fcmToken,
    this.emailVerifiedAt,
    required this.isAdmin,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.isNotificationEnable,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      imageUrl: json['image_url'],
      fcmToken: json['fcm_token'],
      emailVerifiedAt: json['email_verified_at'],
      isAdmin: json['is_admin'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      isNotificationEnable: json['is_notification_enable'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'image_url': imageUrl,
    'fcm_token': fcmToken,
    'email_verified_at': emailVerifiedAt,
    'is_admin': isAdmin,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'deleted_at': deletedAt,
    'is_notification_enable': isNotificationEnable,
  };
}

class UserDetail {
  final int userId;
  final String gender;
  final String userName;
  final int age;
  final String currentWeightType;
  final int currentWeight;
  final String targetWeightType;
  final int targetWeight;
  final String heightType;
  final int height;
  final String updatedAt;
  final String createdAt;
  final int id;

  UserDetail({
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
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      userId: json['user_id'],
      gender: json['gender'],
      userName: json['user_name'],
      age: json['age'],
      currentWeightType: json['current_weight_type'],
      currentWeight: json['current_weight'],
      targetWeightType: json['target_weight_type'],
      targetWeight: json['target_weight'],
      heightType: json['height_type'],
      height: json['height'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'gender': gender,
    'user_name': userName,
    'age': age,
    'current_weight_type': currentWeightType,
    'current_weight': currentWeight,
    'target_weight_type': targetWeightType,
    'target_weight': targetWeight,
    'height_type': heightType,
    'height': height,
    'updated_at': updatedAt,
    'created_at': createdAt,
    'id': id,
  };
}
