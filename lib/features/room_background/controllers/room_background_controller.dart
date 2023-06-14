import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomBackgroundControllerProvider =
    ChangeNotifierProvider((ref) => RoomBackgroundController());
const recommendYoutubeIds = [
  "gvqhjyjiguM",
  "X2-EVyGFWqA",
  "Z_JU4NE90gI",
  "8FMBtusLdPU",
  "cLOP0Kr36ZA",
  "y27-OpyQJeE",
  "iMj3NNCNmBE",
  "B6eL_N0N5KI",
  "1oahTaVIQvk"
];

class RoomBackgroundController extends ChangeNotifier {}
