class ApiResult {
  ApiResult({required this.success, required this.message, this.raw});

  final bool success;
  final String message;
  final dynamic raw;

  factory ApiResult.fromDynamic(dynamic data) {
    if (data is Map<String, dynamic>) {
      return ApiResult(
        success: data['status'] == true ||
            data['success'] == true ||
            data['message'] != null,
        message: (data['message'] ?? data['msg'] ?? 'Success').toString(),
        raw: data,
      );
    }
    return ApiResult(success: true, message: 'Success', raw: data);
  }
}
