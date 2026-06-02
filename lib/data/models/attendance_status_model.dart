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
    dynamic data = response;
    if (response is Map<String, dynamic>) {
      data = response['data'] ?? response['attendance'] ?? response['result'] ?? response;
    }

    String status = '';
    String markedAt = '';
    String markedOutAt = '';

    if (data is Map<String, dynamic>) {
      status = (data['attendance_status'] ??
              data['status'] ??
              data['attendanceStatus'] ??
              '')
          .toString()
          .toLowerCase();

      markedAt = (data['marked_at'] ??
              data['mark_in_time'] ??
              data['check_in'] ??
              data['checked_in_at'] ??
              data['in_time'] ??
              data['time'] ??
              '')
          .toString();

      markedOutAt = (data['mark_out_time'] ??
              data['check_out'] ??
              data['checked_out_at'] ??
              data['out_time'] ??
              data['ended_at'] ??
              '')
          .toString();
    }

    final isOut = status.contains('out') ||
        status.contains('completed') ||
        status.contains('complete') ||
        status.contains('ended');

    final isIn = (status.contains('in') || status.contains('started')) && !isOut;

    return AttendanceStatusModel(
      isMarkedIn: isIn,
      isCompleted: isOut,
      statusText: status.isEmpty ? 'not_marked' : status,
      markedAt: markedAt,
      markedOutAt: markedOutAt,
    );
  }
}
