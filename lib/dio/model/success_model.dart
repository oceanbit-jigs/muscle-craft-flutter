class SuccessModel {
  bool? status;
  String? message;
  dynamic data;
  Map<String,dynamic>? errors;

  SuccessModel({this.status, this.message, this.data,this.errors});

  SuccessModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'];
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['errors'] = errors;
    return data;
  }
}

