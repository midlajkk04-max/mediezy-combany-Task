import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../data/models/attendance_status_model.dart';
import '../data/repositories/attendance_repository.dart';

class AttendanceViewModel extends ChangeNotifier {
  AttendanceViewModel(this._repo);
  final AttendanceRepository _repo;

  bool isLoading = false;
  String? error;
  AttendanceStatusModel status = const AttendanceStatusModel(
    isMarkedIn: false,
    isCompleted: false,
    statusText: 'not_marked',
    markedAt: '',
    markedOutAt: '',
  );

  Future<void> loadStatus() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      status = await _repo.status();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> markAttendance() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();
      final pos = await _currentPosition();
      await _repo.mark(
        attendanceStatus: status.isMarkedIn ? 'mark_out' : 'mark_in',
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
      await loadStatus();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Position> _currentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Please turn on location service');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw Exception('Location permission required');
    }
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}
