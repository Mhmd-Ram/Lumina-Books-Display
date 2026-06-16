/// A single, user-friendly error type the UI can display.
///
/// Every failure inside [ApiClient] is mapped to this so the presentation layer
/// only ever has to deal with one kind of error.
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}
