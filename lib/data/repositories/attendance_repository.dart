import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/api_result.dart';
import '../models/attendance_status_model.dart';

class AttendanceRepository {
  AttendanceRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<AttendanceStatusModel> status() async {
    final data = await _apiClient.get(ApiEndpoints.attendanceStatus);
    return AttendanceStatusModel.fromDynamic(data);
  }

  Future<ApiResult> mark({
    required String attendanceStatus,
    required double latitude,
    required double longitude,
  }) async {
    final data = await _apiClient.post(ApiEndpoints.attendanceMark, {
      'attendance_status': attendanceStatus,
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
    });
    return ApiResult.fromDynamic(data);
  }
}
