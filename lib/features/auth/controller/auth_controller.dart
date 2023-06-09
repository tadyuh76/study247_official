import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/constants/firebase.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/core/utils.dart';
import 'package:study247/features/auth/repository/auth_repository.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserModel?>>(
  (ref) => AuthController(ref: ref)..init(),
);

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  final Ref _ref;
  UserModel? _user;

  AuthController({required Ref ref})
      : _ref = ref,
        super(const AsyncLoading());

  UserModel? get user => _user;
  Stream<User?> get authStateChanges =>
      _ref.watch(authProvider).authStateChanges();

  Future<void> updateUser() async {
    final userId = _ref.read(authProvider).currentUser!.uid;
    final updatedUser = await _ref
        .read(firestoreProvider)
        .collection(FirebaseConstants.users)
        .doc(userId)
        .get();
    state = AsyncData(UserModel.fromMap(updatedUser.data()!));
  }

  Future<void> init() async {
    final firebaseUser = _ref.read(authProvider).currentUser;
    if (firebaseUser == null) {
      state = const AsyncData(null);
      return;
    }

    final userId = firebaseUser.uid;
    final snapshot = await _ref
        .read(firestoreProvider)
        .collection(FirebaseConstants.users)
        .doc(userId)
        .get();
    final appUser = UserModel.fromMap(snapshot.data()!);
    state = AsyncData(appUser);
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final result = await _ref.read(authRepositoryProvider).signInWithGoogle();
    if (result case Success()) {
      await updateUser();

      if (mounted) {
        showSnackBar(context, "Đã đăng nhập thành công!");
      }
    } else if (result case Failure(failure: final failure)) {
      if (mounted) {
        showSnackBar(context, failure.toString());
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    final result = await _ref.read(authRepositoryProvider).signOut();
    if (result case Success()) {
      state = const AsyncData(null);
    } else if (result case Failure(failure: final failure)) {
      if (mounted) {
        showSnackBar(context, failure.toString());
      }
    }
  }
}
