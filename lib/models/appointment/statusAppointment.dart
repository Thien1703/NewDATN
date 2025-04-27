class ApiResponse<T> {
  final int statusCode;
  final T? data;
  final String? message;

  ApiResponse({
    required this.statusCode,
    this.data,
    this.message,
  });
}
