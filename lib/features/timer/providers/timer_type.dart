import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TimerType { personal, room }

final timerTypeProvider = StateProvider((ref) => TimerType.room);
