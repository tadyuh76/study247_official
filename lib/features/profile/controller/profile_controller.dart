import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/notification/controller/notification_controller.dart';
import 'package:study247/features/profile/repository/profile_repository.dart';
import 'package:study247/utils/show_snack_bar.dart';

final profileControllerProvider = Provider((ref) => ProfileController(ref));

class ProfileController {
  final Ref _ref;
  ProfileController(this._ref);

  void updateStudyTime() {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    _ref.read(profileRepositoryProvider).updateStudyTime(userId);
  }

  void requestFriend(String friendId) async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    _ref.read(profileRepositoryProvider).requestFriend(userId, friendId);
    _ref.read(authControllerProvider.notifier).requestFriend(friendId);
    _ref.read(notificationControllerProvider.notifier).requestFriend(friendId);
  }

  void addFriend(String friendId) async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    _ref.read(profileRepositoryProvider).requestFriend(userId, friendId);
    _ref.read(authControllerProvider.notifier).requestFriend(friendId);
  }

  void unFriend(String friendId) async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    _ref.read(profileRepositoryProvider).unFriend(userId, friendId);
    _ref.read(authControllerProvider.notifier).unFriend(friendId);
  }

  void unRequest(String friendId) async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    _ref.read(profileRepositoryProvider).unRequest(userId, friendId);
    _ref.read(authControllerProvider.notifier).unRequest(friendId);
    _ref.read(notificationControllerProvider.notifier).unRequest(friendId);
  }

  Future<void> updateUserStatus({
    required UserStatus status,
    required String studyingRoomId,
    required String studyingMeetingId,
  }) async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    await _ref
        .read(profileRepositoryProvider)
        .updateUserStatus(userId, status, studyingRoomId, studyingMeetingId);
  }

  Future<void> updateProfile(
    BuildContext context, {
    String? newDisplayName,
    Uint8List? imageBytes,
  }) async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    final result = await _ref.read(profileRepositoryProvider).updateProfile(
          userId: userId,
          newDisplayName: newDisplayName,
          imageBytes: imageBytes,
        );

    if (result case Success()) {
      if (context.mounted) {
        _ref.read(authControllerProvider.notifier).updateUser();
        showSnackBar(context, "Chỉnh sửa thông tin thành công!");
      }
    } else {
      if (context.mounted) {
        showSnackBar(context, 'Đã có lỗi xảy ra khi chỉnh sửa thông tin!');
      }
    }
    if (context.mounted) context.pop();
  }
}
