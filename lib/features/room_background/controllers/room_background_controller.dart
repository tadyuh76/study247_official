import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/utils/youtube.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

final roomBackgroundControllerProvider =
    ChangeNotifierProvider((ref) => RoomBackgroundController());
const recommendYoutubeIds = [
  "gvqhjyjiguM",
  "X2-EVyGFWqA",
  "Z_JU4NE90gI",
  "KZvRN5RHvC0",
  "YQc4WT0yDH4",
  "Y58kN2CmFwA",
  "p5vZBOVTUww",
  "B6eL_N0N5KI",
  "1oahTaVIQvk"
];

class RoomBackgroundController extends ChangeNotifier {
  final urlController = TextEditingController();
  final videoController = YoutubePlayerController(
    initialVideoId: "1oahTaVIQvk",
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      disableDragSeek: true,
      enableCaption: false,
      hideControls: true,
      isLive: false,
      loop: true,
      showLiveFullscreenButton: false,
      controlsVisibleAtStart: false,
      hideThumbnail: true,
      forceHD: true,
    ),
  );
  int selectingVideoIdx = -1;
  bool isBackgroundImage = true;

  void updateSelectingVideoIdx(int index) {
    selectingVideoIdx = index;
    notifyListeners();
  }

  void loadVideoOnSelect() {
    isBackgroundImage = false;
    videoController.load(recommendYoutubeIds[selectingVideoIdx]);
    videoController.play();
    notifyListeners();
  }

  void loadVideoByURL() {
    isBackgroundImage = false;
    selectingVideoIdx = -1;
    final text = urlController.text.trim();

    if (isYoutubeUrl(text)) {
      final videoId = getYoutubeId(text);
      videoController.load(videoId);
      videoController.play();
    }
    notifyListeners();
  }

  void reset() {
    urlController.dispose();
    videoController.reset();
    // videoController.enterFullScreen()
  }
}
