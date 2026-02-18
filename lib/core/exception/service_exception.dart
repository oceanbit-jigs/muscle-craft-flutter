class ServiceException implements Exception {
  ServiceException({
    required this.message,
    //this.error,
  });

  final String message;
//final ErrorModel? error;
}