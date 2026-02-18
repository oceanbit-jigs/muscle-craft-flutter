class LoginResponseModel {
  final bool status;
  final String message;
  final UserData data;
  final String token;

  LoginResponseModel({
    required this.status,
    required this.message,
    required this.data,
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: UserData.fromJson(json['data'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data.toJson(),
    'token': token,
  };
}

class UserData {
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

  UserData({
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
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      imageUrl: json['image_url'] as String?,
      fcmToken: json['fcm_token'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      isAdmin: json['is_admin'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      deletedAt: json['deleted_at'] as String?,
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
  };
}
