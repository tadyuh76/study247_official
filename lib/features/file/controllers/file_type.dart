import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FileType { online, offline }

final fileTypeProvider = StateProvider((ref) => FileType.online);
