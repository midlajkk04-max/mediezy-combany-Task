import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class DashboardActionCard extends StatelessWidget {
  const DashboardActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.dark = false,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 105,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: dark ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 5)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: dark ? Colors.white : AppColors.darkPrimary,
              child: Icon(icon,
                  color: dark ? AppColors.darkPrimary : Colors.white, size: 18),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: dark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
