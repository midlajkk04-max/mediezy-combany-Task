class ApiResponseModel {
  bool success;
  String message;
  dynamic data;

  ApiResponseModel({
    this.success = true,
    this.message = '',
    this.data,
  });

  factory ApiResponseModel.fromDynamic(dynamic response) {
    if (response is Map<String, dynamic>) {
      final success = response['status'] == true ||
          response['success'] == true ||
          response['error'] == false;
      return ApiResponseModel(
        success: success,
        message: (response['message'] ?? response['msg'] ?? response['error_message'] ?? '').toString(),
        data: response['data'] ?? response,
      );
    }
    return ApiResponseModel(
      success: true,
      message: 'Success',
      data: response,
    );
  }
}
