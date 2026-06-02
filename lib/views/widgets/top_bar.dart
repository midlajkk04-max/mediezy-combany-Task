import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.title, this.showBack = true});

  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showBack)
          InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios_new, size: 22),
          ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        ),
        const CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.darkPrimary,
          child: Icon(Icons.person, color: Colors.white, size: 20),
        ),
      ],
    );
  }
}
