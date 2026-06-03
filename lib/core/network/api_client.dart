import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_endpoints.dart';

class ApiClient {
  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token') ?? '';

          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  late final Dio _dio;

  Future<dynamic> get(String path) async {
    try {
      final Response response = await _dio.get(path);
      return response.data;
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  Future<dynamic> post(String path, Map<String, dynamic> data) async {
    try {
      final Response response = await _dio.post(path, data: data);
      return response.data;
    } on DioException catch (e) {
      throw Exception(_errorMessage(e));
    }
  }

  String _errorMessage(DioException e) {
  final data = e.response?.data;

  if (data is Map && data['message'] != null) {
    return data['message'].toString();
  }

  if (data is Map && data['error'] != null) {
    return data['error'].toString();
  }

  if (data is String && data.trim().isNotEmpty) {
    return data;
  }

  return e.message ?? 'Something went wrong';
}
}
