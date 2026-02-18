// class ServerException implements Exception {}
class ServerException implements Exception {
  final String message;

  ServerException({
    required this.message,
  });
}

class EmptyCacheException implements Exception {}

class OfflineException implements Exception {}

class TooManyRequestsException implements Exception {}

class UsedMobileNumberException implements Exception {}

class UserNotFoundException implements Exception {}

class NotVerifiedException implements Exception {}

// class ErorrAddingCarException implements Exception {
//  final String message;
//
//   ErorrAddingCarException(this.message);
// }
// class ErorrApplyingCouponException implements Exception {
//  final String message;
//
//  ErorrApplyingCouponException(this.message);
//
// }
class CustomError implements Exception {
  final String message;

  CustomError({
    required this.message,
  });
}
