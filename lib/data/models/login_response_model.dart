class LoginResponseModel {
  String token;
  String userId;
  String employeeId;
  String name;
  String mobile;
  String email;
  String location;
  String role;

  LoginResponseModel({
    this.token = '',
    this.userId = '',
    this.employeeId = '',
    this.name = '',
    this.mobile = '',
    this.email = '',
    this.location = '',
    this.role = '',
  });

  factory LoginResponseModel.fromJson(dynamic json) {
    Map<String, dynamic> map = {};
    if (json is Map) {
      final data = json['data'] ?? json['user'] ?? json['employee'] ?? json;
      if (data is Map) {
        map = Map<String, dynamic>.from(data);
      }
    }

    final first = (map['first_name'] ?? '').toString();
    final last = (map['last_name'] ?? '').toString();
    final fullName = (map['name'] ?? map['full_name'] ?? '$first $last').toString().trim();

    String extractToken(dynamic response) {
      if (response is Map) {
        const keys = ['token', 'access_token', 'auth_token', 'bearer_token', 'api_token'];
        for (final key in keys) {
          if (response[key] != null && response[key].toString().trim().isNotEmpty) {
            return response[key].toString();
          }
        }
        if (response['authorisation'] is Map) {
          final auth = response['authorisation'] as Map;
          return extractToken(auth);
        }
        for (final entry in response.entries) {
          final found = extractToken(entry.value);
          if (found.isNotEmpty) return found;
        }
      }
      return '';
    }

    String rawToken = extractToken(json);
    if (rawToken.toLowerCase().startsWith('bearer ')) {
      rawToken = rawToken.substring(7).trim();
    }

    return LoginResponseModel(
      token: rawToken,
      userId: (map['id'] ?? map['user_id'] ?? map['staff_id'] ?? '').toString(),
      employeeId: (map['employee_id'] ?? map['emp_id'] ?? map['id'] ?? '').toString(),
      name: fullName.isEmpty ? 'User' : fullName,
      mobile: (map['mobile_number'] ?? map['mobile'] ?? map['phone'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      location: (map['location'] ?? map['address'] ?? '').toString(),
      role: (map['role'] ?? map['user_type'] ?? map['designation'] ?? '').toString(),
    );
  }
}
