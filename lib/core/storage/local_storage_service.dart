import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _tokenKey = 'token';
  static const String _userIdKey = 'user_id';
  static const String _employeeIdKey = 'employee_id';
  static const String _nameKey = 'name';
  static const String _mobileKey = 'mobile';
  static const String _locationKey = 'location';
  static const String _roleKey = 'role';
  static const String _emailKey = 'email';

  Future<void> saveLogin({
    required String token,
    required String userId,
    required String employeeId,
    required String name,
    required String mobile,
    String location = '',
    String role = '',
    String email = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_employeeIdKey, employeeId);
    await prefs.setString(_nameKey, name);
    await prefs.setString(_mobileKey, mobile);
    await prefs.setString(_locationKey, location);
    await prefs.setString(_roleKey, role);
    await prefs.setString(_emailKey, email);
  }

  Future<bool> get isLoggedIn async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<String> get token async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? '';
  }

  Future<String> get userId async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey) ?? '';
  }

  Future<String> get employeeId async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_employeeIdKey) ?? '';
  }

  Future<String> get name async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? 'User';
  }

  Future<String> get mobile async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_mobileKey) ?? '';
  }

  Future<String> get location async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_locationKey) ?? '';
  }

  Future<String> get role async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey) ?? '';
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
