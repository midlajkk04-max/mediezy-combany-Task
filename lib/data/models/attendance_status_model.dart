class AttendanceStatusModel {
  const AttendanceStatusModel({
    required this.isMarkedIn,
    required this.isCompleted,
    required this.statusText,
    required this.markedAt,
    required this.markedOutAt,
  });

  final bool isMarkedIn;
  final bool isCompleted;
  final String statusText;
  final String markedAt;
  final String markedOutAt;

  factory AttendanceStatusModel.fromDynamic(dynamic response) {
    dynamic attendanceData;
    if (response is Map<String, dynamic>) {
      attendanceData = response['data'] ?? response['attendance'];
    }

    if (attendanceData is! Map<String, dynamic>) {
      return const AttendanceStatusModel(
        isMarkedIn: false,
        isCompleted: false,
        statusText: 'not_marked',
        markedAt: '',
        markedOutAt: '',
      );
    }

    String extract(List<String> keys, [String defaultVal = '']) {
      for (final key in keys) {
        final v = attendanceData[key];
        if (v != null && v.toString().trim().isNotEmpty) return v.toString();
      }
      return defaultVal;
    }

    final status = extract([
      'attendance_status',
      'status',
      'attendanceStatus',
    ]).toLowerCase();

    final markedAt = extract([
      'marked_at',
      'mark_in_time',
      'check_in',
      'checked_in_at',
      'in_time',
      'time',
    ]);

    final markedOutAt = extract([
      'mark_out_time',
      'check_out',
      'checked_out_at',
      'out_time',
      'ended_at',
    ]);

    const exactMarkedIn = {'marked_in', 'checked_in', 'in', 'started', '1'};
    const exactMarkedOut = {
      'marked_out',
      'checked_out',
      'out',
      'completed',
      'complete',
      'ended',
      '2',
    };

    final isOut = exactMarkedOut.contains(status);
    final isIn = exactMarkedIn.contains(status) && !isOut;

    return AttendanceStatusModel(
      isMarkedIn: isIn,
      isCompleted: isOut,
      statusText: status.isEmpty ? 'not_marked' : status,
      markedAt: markedAt,
      markedOutAt: markedOutAt,
    );
  }
}
