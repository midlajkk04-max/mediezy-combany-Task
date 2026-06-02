import 'package:flutter/material.dart';
import '../core/utils/session_manager.dart';

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel(this._sessionManager);
  final SessionManager _sessionManager;

  String name = 'User';

  Future<void> loadUser() async {
    name = await _sessionManager.name;
    notifyListeners();
  }
}
