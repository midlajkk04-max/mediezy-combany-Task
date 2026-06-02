import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/utils/session_manager.dart';
import '../data/models/leave_model.dart';
import '../data/repositories/leave_repository.dart';

class LeaveViewModel extends ChangeNotifier {
  LeaveViewModel(this._repo, this._sessionManager);
  final LeaveRepository _repo;
  final SessionManager _sessionManager;

  bool isLoading = false;
  String? error;
  String selectedFilter = 'all';
  String selectedMonth = DateFormat('MM').format(DateTime.now());
  List<LeaveModel> leaves = [];

  Future<bool> applyLeave({
    required String leaveMode,
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
  }) async {
    if (startDate.isEmpty || endDate.isEmpty || reason.trim().isEmpty || leaveType.trim().isEmpty) {
      error = 'Please fill all fields';
      notifyListeners();
      return false;
    }

    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final userId = await _sessionManager.userId;
      final employeeId = await _sessionManager.employeeId;

      if (userId.isEmpty && employeeId.isEmpty) {
        throw Exception('Login user id missing. Please logout and login again.');
      }

      await _repo.applyLeave(
        leaveMode: leaveMode,
        leaveType: leaveType.trim(),
        startDate: startDate,
        endDate: endDate,
        reason: reason.trim(),
        userId: userId.isNotEmpty ? userId : employeeId,
        employeeId: employeeId,
      );

      selectedMonth = _monthFromDate(startDate);
      selectedFilter = 'pending';
      await loadLeaves('pending', month: selectedMonth);
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadLeaves(String filter, {String? month}) async {
    try {
      isLoading = true;
      selectedFilter = filter;
      selectedMonth = month ?? selectedMonth;
      error = null;
      notifyListeners();

      final employeeId = await _sessionManager.employeeId;
      final userId = await _sessionManager.userId;

      if (employeeId.isEmpty && userId.isEmpty) {
        throw Exception('Login session missing. Please logout and login again.');
      }

      leaves = await _repo.leaves(
        employeeId: employeeId,
        userId: userId,
        leaveType: filter,
        month: selectedMonth,
      );
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _monthFromDate(String date) {
    // Expected format: yyyy-MM-dd
    if (date.length >= 7 && date[4] == '-') return date.substring(5, 7);
    return DateFormat('MM').format(DateTime.now());
  }
}
