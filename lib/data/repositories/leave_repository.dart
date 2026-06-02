import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../models/api_result.dart';
import '../models/leave_model.dart';

class LeaveRepository {
  LeaveRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<ApiResult> applyLeave({
    required String leaveMode,
    required String leaveType,
    required String startDate,
    required String endDate,
    required String reason,
    required String userId,
    required String employeeId,
  }) async {
    final body = {
      'leave_mode': leaveMode,
      'leave_type': leaveType,
      'start_date': startDate,
      'end_date': endDate,
      'reason': reason,
      'user_id': int.tryParse(userId) ?? 0,
    };

    
    print('APPLY LEAVE REQUEST: $body');
    final data = await _apiClient.post(ApiEndpoints.applyLeave, body);
    
    print('APPLY LEAVE RESPONSE: $data');
    return ApiResult.fromDynamic(data);
  }

  Future<List<LeaveModel>> leaves({
    required String employeeId,
    required String userId,
    required String leaveType,
    required String month,
  }) async {
    final body = {
      'employee_id': int.tryParse(employeeId.isNotEmpty ? employeeId : userId) ?? 0,
      'leave_type': leaveType,
      'month': month,
    };

    
    print('LEAVE LIST REQUEST: $body');
    final data = await _apiClient.post(ApiEndpoints.leaves, body);
    
    print('LEAVE LIST RESPONSE: $data');
    return LeaveModel.listFromDynamic(data);
  }
}
