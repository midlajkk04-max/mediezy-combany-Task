class RouteModel {
  const RouteModel({
    required this.id,
    required this.name,
    required this.date,
    required this.markIn,
    required this.markOut,
    required this.latitude,
    required this.longitude,
  });

  final String id;
  final String name;
  final String date;
  final String markIn;
  final String markOut;
  final double latitude;
  final double longitude;

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? json['employee_name'] ?? 'Route').toString(),
      date: (json['date'] ?? json['created_at'] ?? '').toString(),
      markIn: (json['mark_in'] ?? json['marked_in_at'] ?? '9:30').toString(),
      markOut: (json['mark_out'] ?? json['marked_out_at'] ?? '6:30').toString(),
      latitude: double.tryParse((json['latitude'] ?? json['lat'] ?? '0').toString()) ?? 0,
      longitude: double.tryParse((json['longitude'] ?? json['lng'] ?? '0').toString()) ?? 0,
    );
  }

  static List<RouteModel> listFromDynamic(dynamic response) {
    dynamic data = response;
    if (response is Map<String, dynamic>) {
      data = response['data'] ?? response['routes'] ?? response['route_list'] ?? [];
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
