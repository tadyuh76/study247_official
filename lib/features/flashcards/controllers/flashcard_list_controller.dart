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

  String get userId => _ref.read(authControllerProvider).asData!.value!.uid;
  String get documentId =>
      _ref.read(documentControllerProvider).asData!.value!.id!;

  Future<int> getFlashcardList() async {
    final result = await _ref
        .read(flashcardListRepositoryProvider)
        .getFlashcardList(userId, documentId);

    if (result case Success(value: final flashcardList)) {
      state = AsyncData(flashcardList);

      final revisableCard = flashcardList.fold(
          0,
          (revisableCard, f) =>
              f.notInRevisableTime ? revisableCard : revisableCard + 1);
      return revisableCard;
    } else if (result case Failure()) {
      state = const AsyncData([]);
    }
    return 0;
  }

  void updateFlashcardList(List<Flashcard> flashcardList) {
    state = AsyncData(flashcardList);
  }

  Future<void> updateStudyMode(String studyMode) async {
    final result = await _ref
        .read(flashcardListRepositoryProvider)
        .updateStudyMode(userId, documentId, studyMode);

    if (result case Success(value: final resetFlashcardList)) {
      state = AsyncData(resetFlashcardList);
    }
  }

  void updateFlashcard(Flashcard updatedFlashcard) {
    state = AsyncData(state.asData!.value
        .map((e) => e.id == updatedFlashcard.id ? updatedFlashcard : e)
        .toList());
  }

  Future<void> recallOK(Flashcard flashcard) async {
    final result = await _ref
        .read(flashcardListRepositoryProvider)
        .recallOK(userId, documentId, flashcard);

    if (result case Success(value: final updatedFlashcard)) {
      updateFlashcard(updatedFlashcard);
    }
  }

  Future<void> recallAgain(Flashcard flashcard) async {
    final result = await _ref
        .read(flashcardListRepositoryProvider)
        .recallAgain(userId, documentId, flashcard);

    if (result case Success(value: final updatedFlashcard)) {
      updateFlashcard(updatedFlashcard);
    }
  }

  Future<void> recallHard(Flashcard flashcard) async {
    final result = await _ref
        .read(flashcardListRepositoryProvider)
        .recallHard(userId, documentId, flashcard);

    if (result case Success(value: final updatedFlashcard)) {
      updateFlashcard(updatedFlashcard);
    }
  }

  Future<void> recallGood(Flashcard flashcard) async {
    final result = await _ref
        .read(flashcardListRepositoryProvider)
        .recallGood(userId, documentId, flashcard);

    if (result case Success(value: final updatedFlashcard)) {
      updateFlashcard(updatedFlashcard);
    }
  }

  Future<void> recallEasy(Flashcard flashcard) async {
    final result = await _ref
        .read(flashcardListRepositoryProvider)
        .recallEasy(userId, documentId, flashcard);

    if (result case Success(value: final updatedFlashcard)) {
      updateFlashcard(updatedFlashcard);
    }
  }
}
