import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.status,
    this.size = 14,
  });

  final String status;
  final double size;

  Color get color {
    final s = status.toLowerCase();
    if (s.contains('approved') || s.contains('completed')) return AppColors.approved;
    if (s.contains('reject') || s.contains('cancel') || s.contains('denied')) return AppColors.danger;
    if (s.contains('pending') || s.contains('review')) return AppColors.warning;
    return AppColors.grey;
  }

  IconData get icon {
    final s = status.toLowerCase();
    if (s.contains('approved') || s.contains('completed')) return Icons.check_circle;
    if (s.contains('reject') || s.contains('cancel') || s.contains('denied')) return Icons.cancel;
    if (s.contains('pending') || s.contains('review')) return Icons.schedule;
    return Icons.help_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: size),
        const SizedBox(width: 4),
        Text(
          status,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: size - 2,
            color: color,
          ),
        ),
      ],
    );
  }
}
