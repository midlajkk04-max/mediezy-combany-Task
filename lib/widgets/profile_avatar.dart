import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.radius = 34,
    this.imageUrl,
    this.backgroundColor,
    this.iconSize,
  });

  final double radius;
  final String? imageUrl;
  final Color? backgroundColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? AppColors.darkPrimary,
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? NetworkImage(imageUrl!)
          : null,
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? Icon(Icons.person, color: Colors.white, size: iconSize ?? radius * 1.4)
          : null,
    );
  }
}
