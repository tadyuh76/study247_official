import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/flashcard.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/features/flashcards/repositories/flashcard_list_repository.dart';

final flashcardListControllerProvider = StreamProvider(
  (ref) => FlashcardListController(ref).getFlashcardList(),
);

class FlashcardListController {
  final Ref _ref;
  FlashcardListController(this._ref) : super();

  Stream<List<Flashcard>> getFlashcardList() {
    final result =
        _ref.read(flashcardListRepositoryProvider).getFlashcardList();

    if (result case Success(value: final flashcardList)) {
      return flashcardList;
    }
    return Stream.value([]);
  }
}
