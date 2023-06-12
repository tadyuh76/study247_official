import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final musicControllerProvider =
    ChangeNotifierProvider((ref) => MusicController());

class MusicController extends ChangeNotifier {
  double lofiVolume = 0;
  double libraryVolume = 0;
  double rainVolume = 0;
}
