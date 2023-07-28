import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/flashcard.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/document/controllers/document_controller.dart';
import 'package:study247/features/flashcards/repositories/flashcard_list_repository.dart';

final flashcardListControllerProvider =
    StateNotifierProvider<FlashcardListController, AsyncValue<List<Flashcard>>>(
  (ref) => FlashcardListController(ref),
);

class FlashcardListController
    extends StateNotifier<AsyncValue<List<Flashcard>>> {
  final Ref _ref;
  FlashcardListController(this._ref) : super(const AsyncLoading());

  Future<int> getFlashcardList() async {
    final result =
        await _ref.read(flashcardListRepositoryProvider).getFlashcardList();

    if (result case Success(value: final flashcardList)) {
      state = AsyncData(flashcardList);
      return flashcardList.length;
    } else if (result case Failure()) {
      state = const AsyncData([]);
    }
    return 0;
  }

  void updateFlashcardList(List<Flashcard> flashcardList) {
    state = AsyncData(flashcardList);
  }

  Future<void> updateStudyMode(String studyMode) async {
    final userid = _ref.read(authControllerProvider).asData!.value!.uid;
    final documentId = _ref.read(documentControllerProvider).asData!.value!.id!;
    final result = await _ref
        .read(flashcardListRepositoryProvider)
        .updateStudyMode(userid, documentId, studyMode);

    if (result case Success(value: final resetFlashcardList)) {
      state = AsyncData(resetFlashcardList);
    }
  }
}
