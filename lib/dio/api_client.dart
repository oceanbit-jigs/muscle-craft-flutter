import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../local_database/local_storage.dart';

class DioClient {
  final Dio dio = Dio();
  Logger logger = Logger();

  DioClient() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          logger.i("Dio: ${options.method}: REQUEST: \n${options.uri}");
          logger.i("Headers: ${options.headers}");
          logger.i("Body: ${options.data}");
          return handler.next(options);
        },
        onResponse: (response, handler) {
          logger.i("Dio RESPONSE: \n${response.data}");
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          logger.e("Dio ERROR: ${e.message}");
          if (e.response != null) {
            if (e.response?.statusCode == 500) {
              print("Internal Server Error: Handle accordingly.");
              return handler.next(
                DioException(
                  requestOptions: RequestOptions(
                    data: {'message': '500 status code', 'status': false},
                  ),
                ),
              );
            } else {
              logger.e("Error Response: ${e.response?.data}");
              return handler.next(e);
            }
          }
        },
      ),
    );
  }

  Future<Response> postMultipartRequest({
    required String url,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    FormData formData = FormData.fromMap(body ?? {});
    logger.i('body : $body');
    try {
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // 'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) {
            // Accept all responses, so we can handle server errors manually
            return status != null && status >= 200 && status < 500;
          },
        ),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        // Handle Dio exception
        return e.response!;
      } else {
        rethrow;
      }
    }
  }

  Future<Response> getRequest({
    required String url,
    Map<String, dynamic>? queryParams,
    Map<String?, dynamic>? body,
    String? needTenant,
    String? token,
  }) async {
    try {
      token ??= await LocalStorage.getToken();
      Response response = await dio.get(
        url,
        data: body,
        queryParameters: queryParams,
        options: Options(
          headers: {
            if (needTenant != null) 'X-TENANT-ID': needTenant,
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        // return e.response!;
        throw e;
      } else {
        rethrow;
      }
    }
  }

  // Future<Response> postRequest({
  //   required String url,
  //   Map<String, dynamic>? body,
  // }) async {
  //   try {
  //     Response response = await dio.post(url, data: jsonEncode(body));
  //     print("post request response : ${response}");
  //     return response;
  //   } catch (e) {
  //     if (e is DioException) {
  //       return e.response!;
  //     } else {
  //       rethrow;
  //     }
  //   }
  // }

  Future<Response> postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      final token = await LocalStorage.getToken();

      final response = await dio.post(
        url,
        data: jsonEncode(body),
        options: Options(
          headers: {
            "Content-Type": "application/json",
            if (token != null && token.isNotEmpty)
              "Authorization": "Bearer $token",
          },
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      print("post request response : ${response.data}");
      return response;
    } on DioException catch (e) {
      print("Dio post error: ${e.response?.data}");

      if (e.response != null) {
        return e.response!;
      } else {
        rethrow;
      }
    }
  }

  Future<Response> putRequest({
    required String url,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      Response response = await dio.put(
        url,
        data: jsonEncode(body),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        // Handle Dio exception
        return e.response!;
      } else {
        rethrow;
      }
    }
  }

  Future<Response> patchRequest({
    required String url,
    Map<String, dynamic>? body,
    String? token,
  }) async {
    try {
      Response response = await dio.patch(
        url,
        data: jsonEncode(body),
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        // Handle Dio exception
        return e.response!;
      } else {
        rethrow;
      }
    }
  }

  Future<Response> deleteRequest({
    required String url,
    Map<String, dynamic>? body,
    String? token,
    String? needTenant,
  }) async {
    try {
      Response response = await dio.delete(
        url,
        data: jsonEncode(body),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            if (needTenant != null) 'X-TENANT-ID': needTenant,
          },
        ),
      );
      return response;
    } catch (e) {
      if (e is DioException) {
        // Handle Dio exception
        return e.response!;
      } else {
        rethrow;
      }
    }
  }

  // Future<Response> postMultiPart({
  //   required String url,
  //   required String fileKey,
  //   required Map<String, dynamic> body,
  //   required String? token,
  //   String? filePath,
  // }) async {
  //   print('body :: $body & $fileKey : $filePath');
  //   FormData formData = FormData.fromMap(body);
  //   if (filePath != null && filePath.isNotEmpty) {
  //     print('body :: $body & $fileKey : $filePath');
  //
  //     formData.files.add(MapEntry(
  //       fileKey,
  //       await MultipartFile.fromFile(filePath,
  //           filename: filePath
  //               .split('/')
  //               .last),
  //     ));
  //   }
  //
  //   try {
  //     Response response = await dio.post(
  //       url,
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $token',
  //           // 'Content-Type': 'application/json',
  //         },
  //       ),
  //     );
  //     return response;
  //   } catch (e, stack) {
  //     print('error :: $e');
  //     print('stack :: $stack');
  //     if (e is DioException) {
  //       // Handle Dio exception
  //       return e.response!;
  //     } else {
  //       rethrow;
  //     }
  //   }
  // }

  // Map<String, String> _getHeaders(String? token, {bool isMultipart = false}) {
  //   return {
  //     'Authorization': 'Bearer $token',
  //     'version': '$version',
  //     'versionCode': '$buildNumber',
  //     'platform': Platform.operatingSystem,
  //     'os': Platform.operatingSystemVersion,
  //     if (!isMultipart) 'Content-Type': 'application/json',
  //   };
  // }

  // Future<Response> postMultiPart({
  //   required String url,
  //   required String fileKey,
  //   required Map<String, dynamic> body,
  //   String? filePath,
  // }) async {
  //   print('Uploading: $filePath');
  //
  //   final formData = FormData.fromMap({...body});
  //
  //   if (filePath != null && filePath.isNotEmpty) {
  //     formData.files.add(MapEntry(
  //       fileKey,
  //       await MultipartFile.fromFile(filePath,
  //           filename: filePath.split('/').last),
  //     ));
  //   }
  //
  //   try {
  //     final response = await dio.post(
  //       url,
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'multipart/form-data',
  //           'Accept': 'application/json',
  //         },
  //       ),
  //     );
  //     return response;
  //   } catch (e, stack) {
  //     print('Upload error: $e');
  //     print('Stack trace: $stack');
  //     if (e is DioException && e.response != null) {
  //       return e.response!;
  //     } else {
  //       rethrow;
  //     }
  //   }
  // }

  Future<Response> postMultiPart({
    required String url,
    required String fileKey,
    required Map<String, dynamic> body,
    String? banner_image,
    String? filePath,
    Uint8List? webFileBytes,
    String? webFileName,
  }) async {
    print('Uploading: $banner_image');
    print("uploading : $filePath");

    final formData = FormData.fromMap({...body});

    // For non-web platforms (mobile, desktop)
    if (!kIsWeb && banner_image != null && banner_image.isNotEmpty) {
      formData.files.add(
        MapEntry(
          fileKey,
          await MultipartFile.fromFile(
            banner_image,
            filename: banner_image.split('/').last,
          ),
        ),
      );
    }

    // For web platform
    if (kIsWeb && webFileBytes != null) {
      formData.files.add(
        MapEntry(
          fileKey,
          MultipartFile.fromBytes(
            webFileBytes,
            filename: webFileName ?? 'upload.jpg',
          ),
        ),
      );
    }

    try {
      final response = await Dio().post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } catch (e, stack) {
      print('Upload error: $e');
      print('Stack trace: $stack');
      if (e is DioException && e.response != null) {
        return e.response!;
      } else {
        rethrow;
      }
    }
  }
}
