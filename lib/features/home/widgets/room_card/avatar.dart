import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';

class Avatar extends StatelessWidget {
  final String photoURL;
  final double radius;
  const Avatar({super.key, required this.photoURL, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Palette.white,
      radius: radius,
      child: ClipOval(
        child: photoURL.isEmpty
            ? SvgPicture.asset(IconPaths.defaultUser)
            : Image.network(
                photoURL,
                fit: BoxFit.cover,
                width: radius * 2,
              ),
      ),
    );
  }
}
