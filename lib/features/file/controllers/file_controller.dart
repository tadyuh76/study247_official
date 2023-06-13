import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/file.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/features/file/repositories/file_repositpry.dart';

final fileControllerProvider =
    StateNotifierProvider<FileController, AsyncValue<File?>>(
  (ref) => FileController(ref),
);

class FileController extends StateNotifier<AsyncValue<File?>> {
  final Ref _ref;
  FileController(this._ref) : super(const AsyncData(null));

  Future<void> pickFile() async {
    state = const AsyncLoading();
    final result = await _ref.read(fileRepositoryProvider).pickFile();
    if (result case Success(value: final file)) {
      state = AsyncData(file);
    } else {
      state = const AsyncData(null);
    }
  }
}
