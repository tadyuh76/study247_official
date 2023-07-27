import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/notification.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/notification/repository/notification_repository.dart';

final notificationControllerProvider = StateNotifierProvider<
    NotificationController, AsyncValue<List<NotificationModel>>>(
  (ref) => NotificationController(ref)..getNotifications(),
);

class NotificationController
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final Ref _ref;
  NotificationController(this._ref) : super(const AsyncLoading());

  Future<void> acceptFriend(String friendId) async {
    final user = _ref.read(authControllerProvider).asData!.value!;
    await _ref
        .read(notificationRepositoryProvider)
        .acceptFriend(user, friendId);

    state = AsyncData(
      state.asData!.value
          .map((e) => e.payload == friendId
              ? e.copyWith(status: NotificationStatus.accepted.name)
              : e)
          .toList(),
    );
  }

  Future<void> rejectFriend(String friendId) async {
    final user = _ref.read(authControllerProvider).asData!.value!;
    await _ref
        .read(notificationRepositoryProvider)
        .rejectFriend(user, friendId);

    state = AsyncData(
      state.asData!.value
          .map((e) => e.payload == friendId
              ? e.copyWith(status: NotificationStatus.rejected.name)
              : e)
          .toList(),
    );
  }

  Future<void> requestFriend(String friendId) async {
    final user = _ref.read(authControllerProvider).asData!.value!;
    await _ref
        .read(notificationRepositoryProvider)
        .requestFriend(user, friendId);
  }

  Future<void> unRequest(String friendId) async {
    final user = _ref.read(authControllerProvider).asData!.value!;
    await _ref.read(notificationRepositoryProvider).unRequest(user, friendId);
  }

  Future<void> getNotifications() async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    final result = await _ref
        .read(notificationRepositoryProvider)
        .getNotifications(userId);

    if (result case Success(value: final notificationList)) {
      state = AsyncData(notificationList);
    } else {
      state = const AsyncData([]);
    }
  }

  Future<void> readAllNotifications() async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    final result = await _ref
        .read(notificationRepositoryProvider)
        .readAllNotifications(userId);

    if (result case Success(value: final readNotificationIds)) {
      if (readNotificationIds.isEmpty) return;

      final newState = state.asData!.value
          .map((e) => readNotificationIds.contains(e.id)
              ? e.copyWith(status: NotificationStatus.seen.name)
              : e)
          .toList();
      state = AsyncData(newState);
    }
  }
}
