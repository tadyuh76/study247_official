import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/flashcard.dart';

final repeatedFlashcardListControllerProvider =
    StateNotifierProvider<FlashcardListController, List<Flashcard>>(
  (ref) => FlashcardListController(),
);

class FlashcardListController extends StateNotifier<List<Flashcard>> {
  FlashcardListController() : super([]);

  void addFlashcard(Flashcard flashcard) {
    state = [...state, flashcard];
  }

  void reset() {
    state = [];
  }
}
