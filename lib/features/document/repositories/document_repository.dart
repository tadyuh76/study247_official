import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/document.dart';
import 'package:study247/core/models/flashcard.dart';
import 'package:study247/core/models/folder.dart';
import 'package:study247/core/models/message.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/document/widgets/study_mode_dialog.dart';
import 'package:study247/features/flashcards/controllers/flashcard_list_controller.dart';
import 'package:study247/features/room/controllers/room_controller.dart';

final documentRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  return DocumentRepository(ref, db);
});

class DocumentRepository {
  final Ref _ref;
  final FirebaseFirestore _db;
  DocumentRepository(this._ref, this._db);

  Future<Result<String, Exception>> changeTitle(
      String userId, String documentId, String newTitle) async {
    try {
      final documentRef = _db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.documents)
          .doc(documentId);
      await documentRef.update({"title": newTitle});

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> updateStudyMode(
      String userId, String documentId, String studyMode) async {
    try {
      final docRef = _db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.documents)
          .doc(documentId);
      docRef.update({"studyMode": studyMode});

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

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
        title: "",
        text: "",
        lastEdit: DateTime.now().toString(),
        color: "blue",
        folderName: "",
        studyMode: StudyMode.longterm.name,
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

  Future<Result<String, Exception>> shareDocumentToRoom(
    Document document,
  ) async {
    try {
      final roomId = _ref.read(roomControllerProvider).asData?.value?.id;
      if (roomId == null) {
        return Failure(
          Exception("Bạn cần trong phòng học để chia sẻ tài liệu!"),
        );
      }

      final db = _ref.read(firestoreProvider);
      final user = _ref.read(authControllerProvider).asData!.value!;
      final docRef = db
          .collection(FirebaseConstants.rooms)
          .doc(roomId)
          .collection(FirebaseConstants.messages)
          .doc();

      final sharedMessage = Message(
        text: "[TITLE]:${document.title}  [TEXT]:${document.text}",
        senderId: user.uid,
        senderName: user.displayName,
        senderPhotoURL: user.photoURL,
        createdAt: DateTime.now().toString(),
        type: "document",
        noteId: document.id,
      );
      docRef.set(sharedMessage.toMap());
      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> copyDocument(
    String userId,
    String title,
    String text,
  ) async {
    try {
      final db = _ref.read(firestoreProvider);
      final newRef = db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.documents)
          .doc();

      final newDocument = Document(
        id: newRef.id,
        title: title,
        text: text,
        lastEdit: DateTime.now().toString(),
        color: "blue",
        folderName: "",
        studyMode: StudyMode.longterm.name,
      );
      await newRef.set(newDocument.toMap());

      _ref.read(flashcardListControllerProvider.notifier).reset();
      readFlashcardsInDoc(text, title, StudyMode.longterm.name, newRef);

      return Success(newRef.id);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> saveDocument(
    String documentId,
    String documentTitle,
    String documentText,
    String studyMode,
  ) async {
    try {
      // save document
      final db = _ref.read(firestoreProvider);
      final userId = _ref.read(authControllerProvider).asData!.value!.uid;
      final docRef = db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.documents)
          .doc(documentId);
      docRef.update({
        "title": documentTitle,
        "text": documentText,
        "lastEdit": DateTime.now().toString(),
      });

      await readFlashcardsInDoc(documentText, documentTitle, studyMode, docRef);

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<void> readFlashcardsInDoc(
    String documentText,
    String documentTitle,
    String studyMode,
    DocumentReference docRef,
  ) async {
    final prevFlashcardList =
        _ref.read(flashcardListControllerProvider).asData?.value ?? [];
    final curFlashcardList =
        _createFlashcards(documentText, documentTitle, studyMode);

    final updatedFlashcardList = curFlashcardList.map((f1) {
      for (final f2 in prevFlashcardList) {
        if (isFlashcardRepeated(f1, f2)) {
          return f2;
        }
      }

      final newRef = docRef.collection(FirebaseConstants.flashcards).doc();
      final updatedIdFlashcard = f1.copyWith(id: newRef.id);
      newRef.set(updatedIdFlashcard.toMap());
      return updatedIdFlashcard;
    }).toList();

    _ref
        .read(flashcardListControllerProvider.notifier)
        .updateFlashcardList(updatedFlashcardList);
  }

  bool isFlashcardRepeated(Flashcard f1, Flashcard f2) {
    return (f1.front == f2.front && f1.back == f2.back);
  }

  List<Flashcard> _createFlashcards(
    String documentText,
    String documentTitle,
    String studyMode,
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

      double priorityRate = 1;
      if (line.startsWith('!')) {
        priorityRate = 1.25;
      } else if (line.startsWith('!!')) {
        priorityRate = 1.5;
      } else if (line.startsWith('!!!')) {
        priorityRate = 2;
      }

      final newFlashcard = Flashcard(
        front: sides[0].trim(),
        back: sides[1].trim(),
        ease: 2.5,
        currentInterval: 1,
        level: 0,
        priorityRate: priorityRate,
        revisableAfter: DateTime.now().toString(),
        type: studyMode,
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

  Future<Result<Document, Exception>> fetchDocumentByUserId(
    String documentId,
    String userId,
  ) async {
    try {
      final db = _ref.read(firestoreProvider);
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

  Future<void> editDocument(Document document) async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    await _ref
        .read(firestoreProvider)
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.documents)
        .doc(document.id)
        .set(document.toMap());
  }

  Future<void> editFolder(Folder folder) async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    await _ref
        .read(firestoreProvider)
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.folders)
        .doc(folder.id)
        .set(folder.toMap());
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

  Future<Result<String, Exception>> deleteFolder(String folderName) async {
    try {
      final db = _ref.read(firestoreProvider);
      final userId = _ref.read(authControllerProvider).asData!.value!.uid;
      final folderRef = db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.folders);

      final toDelete =
          await folderRef.where("name", isEqualTo: folderName).get();
      for (final doc in toDelete.docs) {
        folderRef.doc(doc.id).delete();
      }

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
