import 'package:flutter/material.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';

class MusicBox extends StatelessWidget {
  const MusicBox({super.key});

  @override
  Widget build(BuildContext context) {
    return FeatureDialog(
      child: Text("oke"),
      title: "Nhạc nền",
      iconPath: IconPaths.music,
    );
  }
}
