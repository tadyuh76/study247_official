import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/flashcard.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/providers/firebase_providers.dart';

final flashcardListRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  return FlashcardListRepository(db);
});

class FlashcardListRepository {
  // final Ref _ref;
  final FirebaseFirestore _db;
  FlashcardListRepository(this._db);

  DocumentReference<Map<String, dynamic>> _flashcardRef(
      String userId, String documentId, String flashcardId) {
    return _db
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.documents)
        .doc(documentId)
        .collection(FirebaseConstants.flashcards)
        .doc(flashcardId);
  }

  CollectionReference<Map<String, dynamic>> _flashcardListRef(
      String userId, String documentId) {
    return _db
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.documents)
        .doc(documentId)
        .collection(FirebaseConstants.flashcards);
  }

  Future<Result<List<Flashcard>, Exception>> getFlashcardList(
      String userId, String documentId) async {
    try {
      final snapshots = await _flashcardListRef(userId, documentId).get();
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
      final flashcardListRef = _flashcardListRef(userId, documentId);

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

  Future<Result<Flashcard, Exception>> recallOK(
    String userId,
    String documentId,
    Flashcard flashcard,
  ) async {
    try {
      final flashcardRef = _flashcardRef(userId, documentId, flashcard.id!);

      final updatedFlashcard = flashcard.copyWith(
        level: flashcard.nextLevelSpeedrun,
        revisableAfter: flashcard.nextRevisableTimeSpeedrun,
      );
      await flashcardRef.set(updatedFlashcard.toMap());

      return Success(updatedFlashcard);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<Flashcard, Exception>> recallAgain(
    String userId,
    String documentId,
    Flashcard flashcard,
  ) async {
    try {
      final flashcardRef = _flashcardRef(userId, documentId, flashcard.id!);

      final updatedFlashcard = flashcard.copyWith(
        ease: max(1.3, flashcard.ease - 0.2),
      );
      await flashcardRef.set(updatedFlashcard.toMap());

      return Success(updatedFlashcard);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<Flashcard, Exception>> recallHard(
    String userId,
    String documentId,
    Flashcard flashcard,
  ) async {
    try {
      final flashcardRef = _flashcardRef(userId, documentId, flashcard.id!);
      final nextInterval = flashcard.nextIntervalHard;

      final updatedFlashcard = flashcard.copyWith(
        level: flashcard.level + 1,
        ease: max(1.3, flashcard.ease - 0.15),
        currentInterval: nextInterval,
        revisableAfter: flashcard.getRevisableTimeLongterm(nextInterval),
      );
      await flashcardRef.set(updatedFlashcard.toMap());

      return Success(updatedFlashcard);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<Flashcard, Exception>> recallGood(
    String userId,
    String documentId,
    Flashcard flashcard,
  ) async {
    try {
      final flashcardRef = _flashcardRef(userId, documentId, flashcard.id!);
      final nextInterval = flashcard.nextIntervalGood;

      final updatedFlashcard = flashcard.copyWith(
        level: flashcard.level + 1,
        ease: flashcard.ease,
        currentInterval: nextInterval,
        revisableAfter: flashcard.getRevisableTimeLongterm(nextInterval),
      );
      await flashcardRef.set(updatedFlashcard.toMap());

      return Success(updatedFlashcard);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<Flashcard, Exception>> recallEasy(
    String userId,
    String documentId,
    Flashcard flashcard,
  ) async {
    try {
      final flashcardRef = _flashcardRef(userId, documentId, flashcard.id!);
      final nextInterval = flashcard.nextIntervalEasy;

      final updatedFlashcard = flashcard.copyWith(
        level: flashcard.level + 1,
        ease: max(1.3, flashcard.ease + 0.15),
        currentInterval: nextInterval,
        revisableAfter: flashcard.getRevisableTimeLongterm(nextInterval),
      );
      await flashcardRef.set(updatedFlashcard.toMap());

      return Success(updatedFlashcard);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
