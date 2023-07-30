import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobileLayout;
  final Widget desktopLayout;
  final Widget? tabletLayout;
  const Responsive({
    super.key,
    required this.mobileLayout,
    required this.desktopLayout,
    this.tabletLayout,
  });

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width <= 500;
  }

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > 500 &&
        MediaQuery.of(context).size.width <= 1000;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > 1000;
  }

  @override
  Widget build(BuildContext context) {
    if (isDesktop(context)) return desktopLayout;
    if (isTablet(context) && tabletLayout != null) return tabletLayout!;
    return mobileLayout;
  }
}
