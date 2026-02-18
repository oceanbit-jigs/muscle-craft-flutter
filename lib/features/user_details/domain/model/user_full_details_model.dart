class UserDetailsResponse {
  final bool status;
  final String message;
  final UserDetailsData data;

  UserDetailsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserDetailsResponse.fromJson(Map<String, dynamic> json) {
    return UserDetailsResponse(
      status: json['status'],
      message: json['message'],
      data: UserDetailsData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message, 'data': data.toJson()};
  }
}

class UserDetailsData {
  final User user;
  final UserDetail userDetail;
  final List<Goal> goals;
  final List<FocusArea> focusAreas;

  UserDetailsData({
    required this.user,
    required this.userDetail,
    required this.goals,
    required this.focusAreas,
  });

  factory UserDetailsData.fromJson(Map<String, dynamic> json) {
    return UserDetailsData(
      user: User.fromJson(json['user']),
      userDetail: UserDetail.fromJson(json['user_detail']),
      goals: (json['goals'] as List).map((e) => Goal.fromJson(e)).toList(),
      focusAreas: (json['focus_areas'] as List)
          .map((e) => FocusArea.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'user_detail': userDetail.toJson(),
      'goals': goals.map((e) => e.toJson()).toList(),
      'focus_areas': focusAreas.map((e) => e.toJson()).toList(),
    };
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? imageUrl;
  final String? fcmToken;
  final String? emailVerifiedAt;
  final int isAdmin;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final int isNotificationEnable;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
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

  Map<String, dynamic> toJson() {
    return {
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
}

class UserDetail {
  final int id;
  final int userId;
  final String gender;
  final String userName;
  final int age;
  final String currentWeightType;
  final String currentWeight;
  final String targetWeightType;
  final String targetWeight;
  final String heightType;
  final String height;
  final String createdAt;
  final String updatedAt;

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
      id: json['id'],
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Goal {
  final int id;
  final String name;
  final String displayName;
  final int status;
  final String createdAt;
  final String updatedAt;

  Goal({
    required this.id,
    required this.name,
    required this.displayName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      name: json['name'],
      displayName: json['display_name'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class FocusArea {
  final int id;
  final String name;
  final String displayName;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  FocusArea({
    required this.id,
    required this.name,
    required this.displayName,
    required this.imageUrl,
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
