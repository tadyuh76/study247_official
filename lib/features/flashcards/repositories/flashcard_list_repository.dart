import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/flashcard.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/document/controllers/document_controller.dart';

final flashcardListRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  return FlashcardListRepository(ref, db);
});

class FlashcardListRepository {
  final Ref _ref;
  final FirebaseFirestore _db;
  FlashcardListRepository(this._ref, this._db);

  Future<Result<List<Flashcard>, Exception>> getFlashcardList() async {
    try {
      final userId = _ref.read(authControllerProvider).asData!.value!.uid;
      final documentId =
          _ref.read(documentControllerProvider).asData!.value!.id;

      final snapshots = await _db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.documents)
          .doc(documentId)
          .collection(FirebaseConstants.flashcards)
          .get();
      final flashcardList =
          snapshots.docs.map((doc) => Flashcard.fromMap(doc.data())).toList();
      return Success(flashcardList);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<Flashcard>, Exception>> updateStudyMode(
      String userId, String documentId, String studyMode) async {
    try {
      final flashcardListRef = _db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.documents)
          .doc(documentId)
          .collection(FirebaseConstants.flashcards);

      final snapshot = await flashcardListRef.get();
      final flashcardList =
          snapshot.docs.map((e) => Flashcard.fromMap(e.data()));

      final resetFlashcardList = flashcardList.map((flashcard) {
        final resetFlashcard = flashcard.copyWith(
          currentInterval: 1,
          ease: 2.5,
          revisableAfter: DateTime.now().toString(),
          level: 0,
          type: studyMode,
        );
        flashcardListRef.doc(flashcard.id).set(resetFlashcard.toMap());

        return resetFlashcard;
      }).toList();

      return Success(resetFlashcardList);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
