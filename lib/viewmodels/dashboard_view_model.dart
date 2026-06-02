import 'package:flutter/material.dart';
import '../core/storage/local_storage_service.dart';
import '../core/utils/session_manager.dart';
import '../data/models/route_model.dart';
import '../data/repositories/route_repository.dart';

class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel(this._sessionManager, this._localStorage);

  final SessionManager _sessionManager;
  final LocalStorageService _localStorage;

  String name = 'User';
  String role = 'Sales Executive';
  String location = '';
  List<RouteModel> recentRoutes = [];
  bool isLoading = false;
  String? error;

  Future<void> loadUser() async {
    name = await _sessionManager.name;
    location = await _localStorage.location;
    final savedRole = await _localStorage.role;
    if (savedRole.isNotEmpty) {
      role = savedRole;
    }
    notifyListeners();
  }

  Future<void> loadRecentRoutes(RouteRepository routeRepo) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final routes = await routeRepo.routeList();
      recentRoutes = routes.take(5).toList();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
