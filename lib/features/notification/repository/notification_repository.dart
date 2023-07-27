import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/notification.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/providers/firebase_providers.dart';

final notificationRepositoryProvider = Provider((ref) {
  final db = ref.read(firestoreProvider);
  return NotificationRepository(db);
});

class NotificationRepository {
  final FirebaseFirestore _db;
  NotificationRepository(this._db);

  Future<Result<String, Exception>> rejectFriend(
    UserModel user,
    String friendId,
  ) async {
    try {
      // user side
      final userRef = _db.collection(FirebaseConstants.users).doc(user.uid);
      final notiRef = userRef.collection(FirebaseConstants.notifications);
      final snapshot =
          await notiRef.where("payload", isEqualTo: friendId).get();
      final notiId = snapshot.docs[0].id;

      await notiRef
          .doc(notiId)
          .update({"status": NotificationStatus.rejected.name});

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> acceptFriend(
    UserModel user,
    String friendId,
  ) async {
    try {
      // user side
      final userRef = _db.collection(FirebaseConstants.users).doc(user.uid);
      final notiRef = userRef.collection(FirebaseConstants.notifications);
      final snapshot =
          await notiRef.where("payload", isEqualTo: friendId).get();
      final notiId = snapshot.docs[0].id;
      await notiRef
          .doc(notiId)
          .update({"status": NotificationStatus.accepted.name});

      // friend side
      final newNotiRef = _db
          .collection(FirebaseConstants.users)
          .doc(friendId)
          .collection(FirebaseConstants.notifications)
          .doc();
      final acceptedNoti = NotificationModel(
        id: newNotiRef.id,
        text: "${user.displayName} đã chấp nhận lời mời kết bạn của bạn.",
        timestamp: DateTime.now().toString(),
        photoURL: user.photoURL,
        payload: "",
        type: NotificationType.friendAccept.name,
        status: NotificationStatus.pending.name,
      );
      await newNotiRef.set(acceptedNoti.toMap());

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> requestFriend(
    UserModel user,
    String friendId,
  ) async {
    try {
      final friendRef = _db.collection(FirebaseConstants.users).doc(friendId);
      final notiRef =
          friendRef.collection(FirebaseConstants.notifications).doc();

      final friendRequest = NotificationModel(
        id: notiRef.id,
        text: "${user.displayName} đã gửi cho bạn một lời mời kết bạn.",
        timestamp: DateTime.now().toString(),
        photoURL: user.photoURL,
        payload: user.uid,
        type: NotificationType.friendRequest.name,
        status: NotificationStatus.pending.name,
      );
      await notiRef.set(friendRequest.toMap());

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> unRequest(
    UserModel user,
    String friendId,
  ) async {
    try {
      // friend side
      final friendRef = _db.collection(FirebaseConstants.users).doc(friendId);
      final notiRef = friendRef.collection(FirebaseConstants.notifications);

      final snapshot =
          await notiRef.where("payload", isEqualTo: user.uid).get();
      final notiId = snapshot.docs[0].id;

      await notiRef.doc(notiId).delete();

      // user side
      final userRef = _db.collection(FirebaseConstants.users).doc(user.uid);
      await userRef.update({
        "friendRequests": FieldValue.arrayRemove([friendId])
      });

      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<List<NotificationModel>, Exception>> getNotifications(
    String userId,
  ) async {
    try {
      final snapshot = await _db
          .collection(FirebaseConstants.users)
          .doc(userId)
          .collection(FirebaseConstants.notifications)
          .orderBy("timestamp", descending: true)
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

  Future<Result<String, Exception>> sendLevelUpNotification(
    String userId,
    int masteryLevel,
  ) async {
    try {
      final userRef = _db.collection(FirebaseConstants.users).doc(userId);
      final notiRef = userRef.collection(FirebaseConstants.notifications).doc();
      final newNoti = NotificationModel(
        id: notiRef.id,
        text: "Bạn vừa đạt cấp độ tháng mới: ${masteryTitles[masteryLevel]}",
        timestamp: DateTime.now().toString(),
        photoURL: "",
        payload: masteryLevel.toString(),
        type: NotificationType.levelUp.name,
        status: NotificationStatus.pending.name,
      );
      await notiRef.set(newNoti.toMap());
      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
