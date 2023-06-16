import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/document.dart';
import 'package:study247/core/models/flashcard.dart';
import 'package:study247/core/models/folder.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/flashcards/controllers/flashcard_list_controller.dart';

final documentRepositoryProvider = Provider((ref) => DocumentRepository(ref));

class DocumentRepository {
  final Ref _ref;
  DocumentRepository(this._ref);

  Future<Result<Document, Exception>> createNewDocument() async {
    try {
      final db = _ref.read(firestoreProvider);
      final userId = _ref.read(authControllerProvider).asData!.value!.uid;
      final newRef = db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.documents)
          .doc();
      final newDocument = Document(
        id: newRef.id,
        title: "Chưa có tiêu đề",
        text: "",
        lastEdit: DateTime.now().toString(),
        color: "blue",
        folderName: "",
      );
      newRef.set(newDocument.toMap());
      return Success(newDocument);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<Folder, Exception>> createNewFolder(
      String name, String color) async {
    try {
      final db = _ref.read(firestoreProvider);
      final userId = _ref.read(authControllerProvider).asData!.value!.uid;
      final newRef = db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.folders)
          .doc();
      final newFolder = Folder(id: newRef.id, name: name, color: color);
      await newRef.set(newFolder.toMap());
      return Success(newFolder);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<int, Exception>> saveDocument(
    String documentId,
    String documentTitle,
    String documentText,
  ) async {
    try {
      final db = _ref.read(firestoreProvider);
      final userId = _ref.read(authControllerProvider).asData!.value!.uid;
      final documentRef = db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.documents)
          .doc(documentId);
      documentRef.update({
        "title": documentTitle,
        "text": documentText,
        "lastEdit": DateTime.now().toString(),
      });

      final currentflashcardList =
          _ref.read(flashcardListControllerProvider).asData?.value ?? [];
      final newFlashcardList = _createFlashcards(documentText, documentTitle);
      final filteredFlashcardList = newFlashcardList.where((f1) {
        for (final f2 in currentflashcardList) {
          if (isFlashcardRepeated(f1, f2)) {
            return false;
          }
        }
        final newRef =
            documentRef.collection(FirebaseConstants.flashcards).doc();
        newRef.set(f1.copyWith(id: newRef.id).toMap());
        _ref.read(flashcardListControllerProvider.notifier).updateFlashcardList(
          [...currentflashcardList, f1.copyWith(id: newRef.id)],
        );
        return true;
      });

      return Success(filteredFlashcardList.length);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  bool isFlashcardRepeated(Flashcard f1, Flashcard f2) {
    return (f1.front == f2.front && f1.back == f2.back);
  }

  List<Flashcard> _createFlashcards(
    String documentText,
    String documentTitle,
  ) {
    final List<Flashcard> flashcardList = [];
    String curTitle = "";
    List<String> sides = [];

    documentText.split("\n").forEach((line) {
      if (line.contains(Constants.documentHeadingSymbol)) {
        curTitle = line.substring(1).trim();
        return;
      }

      if (line.contains(Constants.flashcardForward)) {
        sides = line.split(Constants.flashcardForward);
      } else if (line.contains(Constants.flashcardBackward)) {
        sides = line.split(Constants.flashcardBackward).reversed.toList();
      } else if (line.contains(Constants.flashcardDouble)) {
        sides = line.split(Constants.flashcardDouble);
      } else {
        return;
      }

      final newFlashcard = Flashcard(
        front: sides[0],
        back: sides[1],
        ease: 1.3,
        currentInterval: 1,
        title: curTitle,
        documentName: documentTitle,
      );
      flashcardList.add(newFlashcard);

      if (line.contains(Constants.flashcardDouble)) {
        flashcardList.add(newFlashcard.copyWith(
          front: newFlashcard.back,
          back: newFlashcard.front,
        ));
      }
    });

    return flashcardList;
  }

  Future<Result<Document, Exception>> fetchDocumentById(
    String documentId,
  ) async {
    try {
      final db = _ref.read(firestoreProvider);
      final userId = _ref.read(authControllerProvider).asData!.value!.uid;
      final snapshot = await db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.documents)
          .doc(documentId)
          .get();
      return Success(Document.fromMap(snapshot.data() as Map<String, dynamic>));
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> deleteDocument(String documentId) async {
    try {
      final db = _ref.read(firestoreProvider);
      final userId = _ref.read(authControllerProvider).asData!.value!.uid;
      await db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.documents)
          .doc(documentId)
          .delete();

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
