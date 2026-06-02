import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.date,
    this.markIn,
    this.markOut,
    this.subtitle,
  });

  final String date;
  final String? markIn;
  final String? markOut;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 4)],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.darkPrimary,
            child: Icon(Icons.person, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.w800)),
                if (subtitle != null)
                  Text(subtitle!,
                      style:
                          const TextStyle(fontSize: 10, color: AppColors.grey))
                else
                  Text(
                    'Marked in at ${markIn ?? '9:30'}  |  Marked out at ${markOut ?? '6:30'}',
                    style: const TextStyle(fontSize: 10, color: AppColors.grey),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
