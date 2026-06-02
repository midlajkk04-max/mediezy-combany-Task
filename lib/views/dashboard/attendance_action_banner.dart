import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/attendance_status_model.dart';

class AttendanceActionBanner extends StatelessWidget {
  const AttendanceActionBanner({
    super.key,
    required this.status,
    required this.isLoading,
    required this.onTap,
  });

  final AttendanceStatusModel status;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AttendanceBannerState bannerState = _bannerState;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.darkPrimary,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  bannerState.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  bannerState.subTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (!bannerState.completed)
            SizedBox(
              height: 36,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.darkPrimary,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: isLoading ? null : onTap,
                icon: isLoading
                    ? const SizedBox(
                        height: 14,
                        width: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.touch_app, size: 15),
                label: Text(
                  bannerState.buttonText,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ),
            ),
        ],
      ),
    );
  }

  AttendanceBannerState get _bannerState {
    if (status.isCompleted) {
      return AttendanceBannerState(
        title: 'Your Day Completed',
        subTitle: 'Started at ${_time(status.markedAt, fallback: '9:29')} Ended at ${_time(status.markedOutAt, fallback: '5:31')}',
        buttonText: '',
        completed: true,
      );
    }

    if (status.isMarkedIn) {
      return AttendanceBannerState(
        title: 'Your work started',
        subTitle: 'Checked In at ${_time(status.markedAt, fallback: '9:29')}',
        buttonText: 'Mark Out',
        completed: false,
      );
    }

    return const AttendanceBannerState(
      title: 'Start Your Day!',
      subTitle: 'Your shift start at 9:30',
      buttonText: 'Mark In',
      completed: false,
    );
  }

  static String _time(String value, {required String fallback}) {
    if (value.trim().isEmpty) return fallback;
    final text = value.trim();
    if (text.length >= 16 && text.contains(' ')) {
      return text.split(' ').last.substring(0, 5);
    }
    if (text.length >= 5) return text.substring(0, 5);
    return text;
  }
}

class AttendanceBannerState {
  const AttendanceBannerState({
    required this.title,
    required this.subTitle,
    required this.buttonText,
    required this.completed,
  });

  final String title;
  final String subTitle;
  final String buttonText;
  final bool completed;
}
