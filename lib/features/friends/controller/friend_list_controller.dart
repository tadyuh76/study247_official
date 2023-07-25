import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/friends/repository/friend_list_repository.dart';

final friendListControllerProvider =
    StateNotifierProvider<FriendListController, AsyncValue<List<UserModel>>>(
  (ref) => FriendListController(ref)..getFriendList(),
);

class FriendListController extends StateNotifier<AsyncValue<List<UserModel>>> {
  final Ref _ref;
  FriendListController(this._ref) : super(const AsyncLoading());

  Future<void> getFriendList() async {
    final friendIds = _ref.read(authControllerProvider).asData!.value!.friends;
    final result =
        await _ref.read(friendListRepositoryProvider).getFriendList(friendIds);

    if (result case Success(value: final friendList)) {
      state = AsyncData(friendList);
    } else if (result case Failure(:final failure)) {
      state = AsyncError(failure, StackTrace.current);
    }
  }
}
