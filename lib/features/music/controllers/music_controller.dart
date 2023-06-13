import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:study247/core/models/audio.dart';

final audioControllerProvider = ChangeNotifierProvider(
  (ref) => AudioController()..init(),
);

class AudioController extends ChangeNotifier {
  Map<String, AudioModel> audio = {
    "lofi": AudioModel(
      "https://firebasestorage.googleapis.com/v0/b/study247-c8c0c.appspot.com/o/lofi.mp3?alt=media&token=abcf072c-b23f-413e-a95b-e372996b9723",
    ),
    "library": AudioModel(
      "https://firebasestorage.googleapis.com/v0/b/study247-c8c0c.appspot.com/o/library.mp3?alt=media&token=1cd0df87-0f9f-4016-8c88-3797297c7894",
    ),
    "rain": AudioModel(
      "https://firebasestorage.googleapis.com/v0/b/study247-c8c0c.appspot.com/o/rain.mp3?alt=media&token=8291cc22-ebec-4519-8359-4e34db289e19",
    ),
  };

  void init() {
    audio.forEach((key, value) {
      value.player.setUrl(value.url);
    });
  }

  void updateVolume(String name, double volume) {
    final currentAudio = audio[name]!;
    currentAudio.volume = volume;

    if (volume > 0) {
      currentAudio.player.setVolume(volume);
      if (!currentAudio.player.playing) {
        currentAudio.player.setLoopMode(LoopMode.one);
        currentAudio.player.play();
      }
    } else {
      currentAudio.player.stop();
    }
    notifyListeners();
  }

  void reset() {
    audio.forEach((key, value) => value.player.dispose());

    audio = {
      "lofi": AudioModel(
        "https://firebasestorage.googleapis.com/v0/b/study247-c8c0c.appspot.com/o/lofi.mp3?alt=media&token=abcf072c-b23f-413e-a95b-e372996b9723",
      ),
      "library": AudioModel(
        "https://firebasestorage.googleapis.com/v0/b/study247-c8c0c.appspot.com/o/library.mp3?alt=media&token=1cd0df87-0f9f-4016-8c88-3797297c7894",
      ),
      "rain": AudioModel(
        "https://firebasestorage.googleapis.com/v0/b/study247-c8c0c.appspot.com/o/rain.mp3?alt=media&token=8291cc22-ebec-4519-8359-4e34db289e19",
      ),
    };
  }
}
