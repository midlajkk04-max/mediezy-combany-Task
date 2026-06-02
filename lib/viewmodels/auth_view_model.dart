import 'package:flutter/material.dart';
import '../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  AuthViewModel(this._repo);
  final AuthRepository _repo;

  bool isLoading = false;
  String? error;

  Future<bool> login(String mobile, String password) async {
    if (mobile.trim().isEmpty || password.trim().isEmpty) {
      error = 'Mobile number and password required';
      notifyListeners();
      return false;
    }
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      await _repo.login(mobileNumber: mobile.trim(), password: password.trim());
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(Map<String, dynamic> body) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      await _repo.register(body);
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() => _repo.logout();
}
