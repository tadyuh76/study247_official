import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/utils/show_snack_bar.dart';
import 'package:study247/features/auth/repositories/auth_repository.dart';

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

  Future<void> init() async {
    final firebaseUser = _ref.read(authProvider).currentUser;
    if (firebaseUser == null) {
      state = const AsyncData(null);
      return;
    }

    final userId = firebaseUser.uid;
    final userResult = await _ref.read(authRepositoryProvider).getUser(userId);
    final appUser = switch (userResult) {
      Success(value: final userModel) => userModel,
      Failure() => null
    };
    state = AsyncData(appUser);
  }

  Future<void> updateUser() async {
    final userId = _ref.read(authProvider).currentUser!.uid;
    final userResult = await _ref.read(authRepositoryProvider).getUser(userId);
    final updatedUser = switch (userResult) {
      Success(value: final userModel) => userModel,
      Failure() => null
    };
    state = AsyncData(updatedUser);
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

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    final result = await _ref
        .read(authRepositoryProvider)
        .signInWithEmailAndPassword(email, password);

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

  Future<void> signUpWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
    String displayName,
  ) async {
    final result = await _ref
        .read(authRepositoryProvider)
        .signUpWithEmailAndPassword(email, password, displayName);

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
