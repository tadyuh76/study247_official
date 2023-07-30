import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class WebLanding extends StatelessWidget {
  const WebLanding({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(60)),
              child: Image.asset(
                "assets/images/logo.png",
                width: 120,
                height: 120,
              ),
            ),
            const SizedBox(width: 20),
            const Text(
              Constants.appName,
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          "Giải pháp học trực tuyến năng suất, tiện lợi",
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 40),
        SvgPicture.asset(
          "assets/illustrations/landing.svg",
          width: 400,
        ),
        const SizedBox(height: 40),
        const Text(
          "Một dự án được xây dựng bởi Đạt Huy.",
          style: TextStyle(fontSize: 16, color: Palette.darkGrey),
        )
      ],
    );
  }
}
