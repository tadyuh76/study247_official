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

enum BackgroundMode { color, video }

class RoomBackgroundController extends ChangeNotifier {
  BackgroundMode mode = BackgroundMode.color;
  String backgroundColor = 'grey';

  final urlController = TextEditingController();
  var videoController = YoutubePlayerController(
    initialVideoId: "1oahTaVIQvk",
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      disableDragSeek: true,
      enableCaption: false,
      hideControls: true,
      isLive: false,
      startAt: 60,
      loop: true,
      showLiveFullscreenButton: false,
      controlsVisibleAtStart: false,
      hideThumbnail: true,
      forceHD: true,
    ),
  );
  int selectingVideoIdx = -1;

  void selectColorBackground(String color) {
    mode = BackgroundMode.color;
    backgroundColor = color;
    videoController.pause();
    notifyListeners();
  }

  void updateSelectingVideoIdx(int index) {
    selectingVideoIdx = index;
    notifyListeners();
  }

  void loadVideoOnSelect() {
    videoController.load(recommendYoutubeIds[selectingVideoIdx], startAt: 30);
    videoController.play();
    mode = BackgroundMode.video;
    notifyListeners();
  }

  void loadVideoByURL() {
    selectingVideoIdx = -1;
    final text = urlController.text.trim();

    if (isYoutubeUrl(text)) {
      final videoId = getYoutubeId(text);
      videoController.load(videoId);
      videoController.play();
    }
    mode = BackgroundMode.video;
    notifyListeners();
  }

  void reset() {
    urlController.dispose();
    videoController.reset();
    videoController = YoutubePlayerController(
      initialVideoId: "1oahTaVIQvk",
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        disableDragSeek: true,
        enableCaption: false,
        hideControls: true,
        isLive: false,
        startAt: 30,
        loop: true,
        showLiveFullscreenButton: false,
        controlsVisibleAtStart: false,
        hideThumbnail: true,
        forceHD: true,
      ),
    );
  }
}
