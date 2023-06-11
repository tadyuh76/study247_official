import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/room.dart';
import 'package:study247/features/room/repositories/room_list_repository.dart';

final roomListControllerProvider =
    StateNotifierProvider<RoomListController, AsyncValue<List<Room>>>(
        (ref) => RoomListController(ref)..getRoomList());

class RoomListController extends StateNotifier<AsyncValue<List<Room>>> {
  final Ref _ref;
  RoomListController(this._ref) : super(const AsyncLoading());

  Future<void> getRoomList({bool refresh = false}) async {
    if (refresh) state = const AsyncLoading();

    final result = await _ref.read(roomListRepositoryProvider).getRoomList();
    if (result case Success(value: final roomList)) {
      state = AsyncData(roomList);
    } else {
      state = const AsyncData([]);
    }
  }
}
