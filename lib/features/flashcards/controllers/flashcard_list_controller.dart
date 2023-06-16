import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/flashcard.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/document/controllers/document_controller.dart';

final flashcardListControllerProvider = StreamProvider(
  (ref) => FlashcardListController(ref).getFlashcardList(),
);

class FlashcardListController {
  final Ref _ref;
  FlashcardListController(this._ref) : super();

  Stream<List<Flashcard>> getFlashcardList() {
    final db = _ref.read(firestoreProvider);
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    final documentId = _ref.watch(documentControllerProvider).asData!.value!.id;

    final snapshots = db
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.documents)
        .doc(documentId)
        .collection(FirebaseConstants.flashcards)
        .snapshots();
    final flashcardList = snapshots.map(
      (event) => event.docs.map((e) => Flashcard.fromMap(e.data())).toList(),
    );
    return flashcardList;
  }
}
