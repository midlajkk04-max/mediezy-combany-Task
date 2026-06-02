import 'package:flutter/material.dart';

abstract final class Responsive {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;
  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;
  static double scale(BuildContext context) => width(context) / 375;
  static double scaleH(BuildContext context) => height(context) / 812;

  static double w(double size, BuildContext context) => size * scale(context);
  static double h(double size, BuildContext context) => size * scaleH(context);
  static double sp(double size, BuildContext context) => size * scale(context);

  static EdgeInsets pad(BuildContext context,
      {double all = 0, double h = 24, double v = 0}) {
    if (all > 0) return EdgeInsets.all(w(all, context));
    return EdgeInsets.symmetric(
        horizontal: w(h, context), vertical: w(v, context));
  }

  static SizedBox gap({double? w, double? h, BuildContext? context}) {
    final ctx = context;
    if (ctx == null) return SizedBox(width: w, height: h);
    return SizedBox(
        width: w != null ? Responsive.w(w, ctx) : null,
        height: h != null ? Responsive.h(h, ctx) : null);
  }
}
