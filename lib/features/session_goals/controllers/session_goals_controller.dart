import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/session_goal.dart';

final sessionGoalsControllerProvider =
    StateNotifierProvider<SessionGoalsController, List<SessionGoal>>(
  (ref) => SessionGoalsController(),
);

class SessionGoalsController extends StateNotifier<List<SessionGoal>> {
  SessionGoalsController() : super([]);

  void addGoal(String content) {
    if (content.trim().isEmpty) return;
    final newGoal = SessionGoal(text: content, completed: false);
    state = [newGoal, ...state];
  }

  void deleteGoal(SessionGoal goal) {
    final removed = state.where((e) => e != goal).toList();
    state = removed;
  }

  void markComplete(SessionGoal goal) {
    final marked = state.map((e) {
      if (e == goal) return e.copyWith(completed: !e.completed);
      return e;
    }).toList();
    state = marked;
  }

  void reset() {
    state = [];
  }
}
