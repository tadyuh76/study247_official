import 'package:just_audio/just_audio.dart';

class AudioModel {
  final String url;
  AudioPlayer player;
  double volume;

  bool get muted => volume == 0;

  AudioModel(this.url)
      : player = AudioPlayer(),
        volume = 0;
}
