import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/utils/session_manager.dart';
import '../models/api_result.dart';
import '../models/user_model.dart';

class AuthRepository {
  AuthRepository(this._apiClient, this._sessionManager);

  final ApiClient _apiClient;
  final SessionManager _sessionManager;

  Future<UserModel> login({
    required String mobileNumber,
    required String password,
  }) async {
    final data = await _apiClient.post(ApiEndpoints.login, {
      'mobile_number': mobileNumber,
      'password': password,
    });

    final token = _extractToken(data);
    final user = UserModel.fromLoginResponse(data);

   
   
    await _sessionManager.saveLogin(
      token: token,
      userId: user.id,
      employeeId: user.employeeId.isNotEmpty ? user.employeeId : user.id,
      name: user.name,
      mobile: user.mobile.isNotEmpty ? user.mobile : mobileNumber,
    );

    return user;
  }

  Future<ApiResult> register(Map<String, dynamic> body) async {
    final data = await _apiClient.post(ApiEndpoints.register, body);
    return ApiResult.fromDynamic(data);
  }

  Future<bool> isLoggedIn() => _sessionManager.isLoggedIn;
  Future<String> name() => _sessionManager.name;
  Future<void> logout() => _sessionManager.logout();

  String _extractToken(dynamic response) {
    final token = _findTokenDeep(response);
    if (token.isEmpty) return '';

   
    if (token.toLowerCase().startsWith('bearer ')) {
      return token.substring(7).trim();
    }
    return token.trim();
  }

  String _findTokenDeep(dynamic value) {
    const tokenKeys = {
      'token',
      'access_token',
      'accessToken',
      'auth_token',
      'authToken',
      'bearer_token',
      'bearerToken',
      'api_token',
      'apiToken',
      'plainTextToken',
      'plain_text_token',
      'personal_access_token',
    };

    if (value is Map) {
      final map = Map<String, dynamic>.from(value);

      for (final entry in map.entries) {
        if (tokenKeys.contains(entry.key) && entry.value != null) {
          final found = entry.value.toString();
          if (found.trim().isNotEmpty) return found;
        }
      }

     
      for (final entry in map.entries) {
        final found = _findTokenDeep(entry.value);
        if (found.trim().isNotEmpty) return found;
      }
    }

    if (value is List) {
      for (final item in value) {
        final found = _findTokenDeep(item);
        if (found.trim().isNotEmpty) return found;
      }
    }

    return '';
  }
}
