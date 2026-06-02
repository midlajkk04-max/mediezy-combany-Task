class RouteModel {
  const RouteModel({
    this.id = '',
    this.name = 'Route',
    required this.date,
    required this.markIn,
    required this.markOut,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.markOutLatitude = 0.0,
    this.markOutLongitude = 0.0,
  });

  final String id;
  final String name;
  final String date;
  final String markIn;
  final String markOut;
  final double latitude;
  final double longitude;
  final double markOutLatitude;
  final double markOutLongitude;

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    String value(List<String> keys, [String defaultVal = '']) {
      for (final key in keys) {
        if (json.containsKey(key) && json[key] != null) {
          return json[key].toString();
        }
      }
      return defaultVal;
    }

    double parseLat(dynamic locationField, String key) {
      if (locationField is Map) {
        final v = locationField[key];
        if (v != null) return double.tryParse(v.toString()) ?? 0.0;
      }
      return 0.0;
    }

    final markInLocation = json['mark_in_location'];
    final markOutLocation = json['mark_out_location'];

    return RouteModel(
      id: value(['id', 'route_id', 'attendance_id']),
      name: value(['name', 'employee_name', 'customer_name'], 'Route'),
      date: value(['date', 'created_at', 'attendance_date']),
      markIn: value(['mark_in', 'marked_in_at', 'check_in', 'in_time']),
      markOut: value(['mark_out', 'marked_out_at', 'check_out', 'out_time']),
      latitude: parseLat(markInLocation, 'latitude'),
      longitude: parseLat(markInLocation, 'longitude'),
      markOutLatitude: parseLat(markOutLocation, 'latitude'),
      markOutLongitude: parseLat(markOutLocation, 'longitude'),
    );
  }

  static List<RouteModel> listFromDynamic(dynamic response) {
    dynamic data = response;
    if (response is Map<String, dynamic>) {
      data = response['data'] ??
          response['routes'] ??
          response['route_list'] ??
          response['attendance'] ??
          [];
    }
    if (data is List) {
      return data
          .whereType<Map>()
          .map((e) => RouteModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    return [];
  }
}
