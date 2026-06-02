import 'package:flutter/material.dart';
import 'profile_avatar.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.showProfile = true,
    this.actions,
  });

  final String title;
  final bool showBack;
  final bool showProfile;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (showBack)
            InkWell(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios_new, size: 22),
            ),
          if (showBack) const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
          ),
          if (actions != null) ...actions!,
          if (showProfile) const ProfileAvatar(radius: 16, iconSize: 20),
        ],
      ),
    );
  }
}
