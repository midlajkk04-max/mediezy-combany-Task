class UserModel {
  const UserModel({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.mobile,
  });

  final String id;
  final String employeeId;
  final String name;
  final String mobile;

  factory UserModel.fromLoginResponse(dynamic response) {
    Map<String, dynamic> map = {};

    if (response is Map) {
      final responseMap = Map<String, dynamic>.from(response);
      final dynamic data = responseMap['data'] ??
          responseMap['user'] ??
          responseMap['employee'] ??
          responseMap['staff'] ??
          responseMap;

      if (data is Map) {
        map = Map<String, dynamic>.from(data);
      }
    }

    final first = (map['first_name'] ?? '').toString();
    final last = (map['last_name'] ?? '').toString();
    final fullName = (map['name'] ?? map['full_name'] ?? '$first $last').toString().trim();

    return UserModel(
      id: (map['id'] ?? map['user_id'] ?? map['staff_id'] ?? '').toString(),
      employeeId: (map['employee_id'] ?? map['emp_id'] ?? map['id'] ?? map['user_id'] ?? '').toString(),
      name: fullName.isEmpty ? 'User' : fullName,
      mobile: (map['mobile_number'] ?? map['mobile'] ?? map['phone'] ?? '').toString(),
    );
  }
}
