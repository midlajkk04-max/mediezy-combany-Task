class LeaveModel {
  const LeaveModel({
    required this.id,
    required this.leaveMode,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
  });

  final String id;
  final String leaveMode;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    String value(List<String> keys, [String defaultValue = '']) {
      for (final key in keys) {
        final v = json[key];
        if (v != null && v.toString().trim().isNotEmpty) return v.toString();
      }
      return defaultValue;
    }

    String parseStatus(dynamic rawStatus) {
      if (rawStatus is int) {
        switch (rawStatus) {
          case 0:
            return 'pending';
          case 1:
            return 'approved';
          case 2:
            return 'rejected';
          default:
            return 'pending';
        }
      }
      if (rawStatus is String) {
        final s = rawStatus.toLowerCase().trim();
        if (s == '0' || s == 'pending') return 'pending';
        if (s == '1' || s == 'approved') return 'approved';
        if (s == '2' || s == 'rejected') return 'rejected';
        return s;
      }
      return 'pending';
    }

    final rawStatus =
        json['status'] ?? json['leave_status'] ?? json['approval_status'] ?? 0;

    return LeaveModel(
      id: value(['id', 'leave_id', 'request_id']),
      leaveMode: value(['leave_mode', 'mode', 'day_type'], 'Full Day'),
      leaveType: value(['leave_type', 'type', 'leave_name'], 'Leave'),
      startDate: value(['start_date', 'from_date', 'from', 'date']),
      endDate: value(['end_date', 'to_date', 'to']),
      reason: value(['reason', 'description', 'leave_reason']),
      status: parseStatus(rawStatus),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'leave_mode': leaveMode,
        'leave_type': leaveType,
        'start_date': startDate,
        'end_date': endDate,
        'reason': reason,
        'status': status,
      };

  static List<LeaveModel> listFromDynamic(dynamic response) {
    final list = _findLeaveList(response);
    return list
        .whereType<Map>()
        .map((e) => LeaveModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  static List<dynamic> _findLeaveList(dynamic value) {
    if (value is List) {
      if (value.isEmpty) return value;
      if (value.first is Map) return value;
    }

    if (value is Map) {
      final map = Map<String, dynamic>.from(value);

      final directKeys = [
        'data',
        'leaves',
        'leave',
        'leave_list',
        'leaveList',
        'sales_executive_leaves',
        'records',
        'result',
        'items',
      ];

      for (final key in directKeys) {
        final found = _findLeaveList(map[key]);
        if (found.isNotEmpty) return found;
      }

      for (final entry in map.entries) {
        final found = _findLeaveList(entry.value);
        if (found.isNotEmpty) return found;
      }
    }

    return <dynamic>[];
  }
}
