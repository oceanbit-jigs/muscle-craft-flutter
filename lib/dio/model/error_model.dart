class ErrorModel {
  bool? status;
  String? message;
  List<Error>? error;

  ErrorModel({status, message, error});

  ErrorModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['error'] != null) {
      error = <Error>[];
      json['error'].forEach((v) {
        error!.add(Error.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (error != null) {
      data['error'] = error!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Error {
  String? key;
  String? error;

  Error({key, error});

  Error.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['key'] = key;
    data['error'] = error;
    return data;
  }
}
