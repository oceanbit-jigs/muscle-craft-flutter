class RegisterResponseModel {
  final bool status;
  final String message;
  final String token;
  final UserData data;

  RegisterResponseModel({
    required this.status,
    required this.message,
    required this.token,
    required this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      status: json['status'],
      message: json['message'],
      token: json['token'],
      data: UserData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "status": status,
      "message": message,
      "token": token,
      "data": data.toJson(),
    };
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? imageUrl;
  final String? fcmToken;
  final String? emailVerifiedAt;
  final int? isAdmin;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  UserData({
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
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "image_url": imageUrl,
      "fcm_token": fcmToken,
      "email_verified_at": emailVerifiedAt,
      "is_admin": isAdmin,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "deleted_at": deletedAt,
    };
  }
}
