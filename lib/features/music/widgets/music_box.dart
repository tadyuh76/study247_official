import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';
import 'package:study247/features/music/controllers/music_controller.dart';

class MusicBox extends ConsumerWidget {
  const MusicBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioController = ref.watch(audioControllerProvider);

    return FeatureDialog(
      title: "Nhạc nền",
      iconPath: IconPaths.music,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Constants.defaultPadding),
          _renderAudioController(audioController, "lofi", "🌠 Lofi"),
          _renderAudioController(audioController, "rain", "📚 Thư viện"),
          _renderAudioController(audioController, "library", "🌧️ Mưa"),
        ],
      ),
    );
  }

  Column _renderAudioController(
    AudioController musicController,
    String name,
    String title,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14)),
        Row(
          children: [
            Icon(
              musicController.audio[name]!.muted
                  ? Icons.volume_off_rounded
                  : Icons.volume_up,
              color: Palette.darkGrey,
            ),
            Expanded(
              child: Slider(
                value: musicController.audio[name]!.volume,
                onChanged: (newVolume) {
                  musicController.updateVolume(name, newVolume);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: Constants.defaultPadding / 2),
      ],
    );
  }
}
