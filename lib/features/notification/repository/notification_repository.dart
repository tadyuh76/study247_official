import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/notification.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/providers/firebase_providers.dart';

final notificationRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  return NotificationRepository(db);
});

class NotificationRepository {
  final FirebaseFirestore _db;
  NotificationRepository(this._db);

  Future<Result<List<NotificationModel>, Exception>> getNotifications(
    String userId,
  ) async {
    try {
      final snapshot = await _db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.notifications)
          .get();
      final notificationList = snapshot.docs
          .map((e) => NotificationModel.fromMap(e.data()))
          .toList();

      return Success(notificationList);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<String>, Exception>> readAllNotifications(
      String userId) async {
    try {
      final notificationsRef = _db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.notifications);

      final snapshot = await notificationsRef
          .where("status", isEqualTo: NotificationStatus.pending.name)
          .get();
      final notificationsToRead = snapshot.docs.map(
        (e) => NotificationModel.fromMap(e.data()),
      );

      for (final notification in notificationsToRead) {
        notificationsRef.doc(notification.id).set(notification
            .copyWith(status: NotificationStatus.seen.name)
            .toMap());
      }

      return Success(notificationsToRead.map((e) => e.id).toList());
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
