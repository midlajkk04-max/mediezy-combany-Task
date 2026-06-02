class AttendanceModel {
  String id;
  String status;
  String markedAt;
  String markedOutAt;
  double latitude;
  double longitude;

  AttendanceModel({
    this.id = '',
    this.status = '',
    this.markedAt = '',
    this.markedOutAt = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    String value(List<String> keys, [String defaultVal = '']) {
      for (final key in keys) {
        if (json.containsKey(key) && json[key] != null) {
          return json[key].toString();
        }
      }
      return defaultVal;
    }

    return AttendanceModel(
      id: value(['id', 'attendance_id', 'record_id']),
      status: value(['attendance_status', 'status', 'mark_type']),
      markedAt: value(['marked_at', 'mark_in_time', 'check_in', 'in_time', 'created_at']),
      markedOutAt: value(['mark_out_time', 'check_out', 'out_time', 'ended_at']),
      latitude: double.tryParse(value(['latitude', 'lat'], '0')) ?? 0.0,
      longitude: double.tryParse(value(['longitude', 'lng', 'lon'], '0')) ?? 0.0,
    );
  }

  static List<AttendanceModel> listFromDynamic(dynamic response) {
    dynamic data = response;
    if (response is Map) {
      data = response['data'] ?? response['attendance'] ?? response['records'] ?? response['list'] ?? [];
    }
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => AttendanceModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }
}
