import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/badge.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/badge/repository/badge_list_repository.dart';
import 'package:study247/features/notification/controller/notification_controller.dart';

final badgeListControllerProvider =
    StateNotifierProvider<BadgeListController, AsyncValue<List<BadgeModel>>>(
  (ref) => BadgeListController(ref)..getBadgeList(),
);

class BadgeListController extends StateNotifier<AsyncValue<List<BadgeModel>>> {
  final Ref _ref;
  BadgeListController(this._ref) : super(const AsyncLoading());

  Future<void> getBadgeList() async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    final result =
        await _ref.read(badgeListRepositoryProvider).getBadgeList(userId);

    if (result case Success(value: final badgeList)) {
      state = AsyncData(badgeList);
    } else if (result case Failure(:final failure)) {
      state = AsyncError(failure, StackTrace.current);
    }
  }

  Future<List<BadgeModel>> getBadgeListById(String userId) async {
    final result =
        await _ref.read(badgeListRepositoryProvider).getBadgeListById(userId);

    if (result case Success(value: final badgeList)) {
      return badgeList;
    } else {
      return [];
    }
  }

  Future<void> addBadges(List<String> newBadges) async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    await _ref.read(badgeListRepositoryProvider).addBadges(userId, newBadges);
    _ref.read(notificationControllerProvider.notifier).getNotifications();
  }
}
