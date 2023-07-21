import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/profile/repository/profile_repository.dart';

final profileControllerProvider = Provider((ref) => ProfileController(ref));

class ProfileController {
  final Ref _ref;
  ProfileController(this._ref);

  void updateStudyTime() {
    final user = _ref.read(authControllerProvider).asData!.value!;
    _ref.read(profileRepositoryProvider).updateStudyTime(user);
  }
}
