import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.message = 'No data found',
    this.icon = Icons.inbox_outlined,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.grey, size: 48),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: AppColors.textGrey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
