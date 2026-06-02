import 'package:flutter/material.dart';
import '../data/models/route_model.dart';
import '../data/repositories/route_repository.dart';

class RouteViewModel extends ChangeNotifier {
  RouteViewModel(this._repo);
  final RouteRepository _repo;

  bool isLoading = false;
  String? error;
  List<RouteModel> routes = [];

  Future<void> loadRoutes() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      routes = await _repo.routeList();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
