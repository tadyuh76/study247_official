import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/flashcard.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/document/controllers/document_controller.dart';

final flashcardListRepositoryProvider =
    Provider((ref) => FlashcardListRepository(ref));

class FlashcardListRepository {
  final Ref _ref;
  FlashcardListRepository(this._ref);

  Future<Result<List<Flashcard>, Exception>> getFlashcardList() async {
    try {
      final db = _ref.read(firestoreProvider);
      final userId = _ref.read(authControllerProvider).asData!.value!.uid;
      final documentId =
          _ref.read(documentControllerProvider).asData!.value!.id;

      final snapshots = await db
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
}
