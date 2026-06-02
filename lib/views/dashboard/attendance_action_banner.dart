import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../../data/models/attendance_status_model.dart';

class AttendanceActionBanner extends StatelessWidget {
  const AttendanceActionBanner(
      {super.key,
      required this.status,
      required this.isLoading,
      required this.onTap});

  final AttendanceStatusModel status;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final s = Responsive.scale(context);
    final state = _bannerState;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: Responsive.w(18, context),
          vertical: Responsive.h(13, context)),
      decoration: BoxDecoration(
          color: AppColors.darkPrimary,
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
                SizedBox(height: 3 * s),
                Text(state.subTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 10)),
              ],
            ),
          ),
          if (!state.completed)
            SizedBox(
              height: 36 * s,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.darkPrimary,
                  padding: EdgeInsets.symmetric(horizontal: 12 * s),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: isLoading ? null : onTap,
                icon: isLoading
                    ? const SizedBox(
                        height: 14,
                        width: 14,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.touch_app, size: 15),
                label: Text(state.buttonText,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w800)),
              ),
            ),
        ],
      ),
    );
  }

  _AttendanceBannerState get _bannerState {
    if (status.isCompleted) {
      return _AttendanceBannerState(
        title: 'Your Day Completed',
        subTitle:
            'Started at ${_time(status.markedAt, fallback: '9:29')} Ended at ${_time(status.markedOutAt, fallback: '5:31')}',
        buttonText: '',
        completed: true,
      );
    }
    if (status.isMarkedIn) {
      return _AttendanceBannerState(
        title: 'Your work started',
        subTitle: 'Checked In at ${_time(status.markedAt, fallback: '9:29')}',
        buttonText: 'Mark Out',
        completed: false,
      );
    }
    return const _AttendanceBannerState(
        title: 'Start Your Day!',
        subTitle: 'Your shift start at 9:30',
        buttonText: 'Mark In',
        completed: false);
  }

  static String _time(String value, {required String fallback}) {
    if (value.trim().isEmpty) return fallback;
    final text = value.trim();
    if (text.length >= 16 && text.contains(' '))
      return text.split(' ').last.substring(0, 5);
    if (text.length >= 5) return text.substring(0, 5);
    return text;
  }
}

class _AttendanceBannerState {
  const _AttendanceBannerState(
      {required this.title,
      required this.subTitle,
      required this.buttonText,
      required this.completed});
  final String title;
  final String subTitle;
  final String buttonText;
  final bool completed;
}
