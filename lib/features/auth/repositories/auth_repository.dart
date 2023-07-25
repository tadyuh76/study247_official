import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/utils/days_in_month.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final auth = ref.read(authProvider);
  final db = ref.read(firestoreProvider);
  return AuthRepository(auth: auth, db: db);
});

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  AuthRepository({required FirebaseAuth auth, required FirebaseFirestore db})
      : _auth = auth,
        _db = db;

  Future<Result<UserCredential, Exception>> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login(
        permissions: ["email", "public_profile"],
        loginBehavior: LoginBehavior.nativeWithFallback,
      );
      if (result.accessToken == null) {
        return Failure(Exception("Đã có lỗi trong quá trình đăng nhập!"));
      }

      final facebookAuthCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      final cred = await _auth.signInWithCredential(facebookAuthCredential);

      if (cred.additionalUserInfo!.isNewUser) {
        _uploadUserToDB(cred);
      }

      return Success(cred);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<UserCredential, Exception>> signInWithGoogle() async {
    try {
      final googleSignIn = await GoogleSignIn().signIn();
      if (googleSignIn == null) {
        return Failure(Exception(Constants.authFailedMessage));
      }

      final googleAuth = await googleSignIn.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user == null) {
        return Failure(Exception(Constants.authFailedMessage));
      }

      if (userCredential.additionalUserInfo!.isNewUser) {
        _uploadUserToDB(userCredential);
      }

      return Success(userCredential);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCred.user != null && userCred.additionalUserInfo!.isNewUser) {
        _uploadUserToDB(userCred);
      }
      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCred.user != null && userCred.additionalUserInfo!.isNewUser) {
        userCred.user!.updateDisplayName(displayName);
        _uploadUserToDB(userCred, displayName: displayName);
      }
      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<UserModel, Exception>> getUser(String uid) async {
    try {
      final user = await _db.collection(FirebaseConstants.users).doc(uid).get();
      return Success(UserModel.fromMap(user.data()!));
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> signOut() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  // private methods
  Future<void> _uploadUserToDB(
    UserCredential userCredential, {
    String? displayName,
    String? email,
    String? photoURL,
    String? uid,
  }) async {
    final thisYear = DateTime.now().year;

    final newUser = UserModel(
      uid: uid ?? userCredential.user!.uid,
      displayName: displayName ?? userCredential.user!.displayName ?? "",
      email: email ?? userCredential.user!.email ?? "",
      photoURL: photoURL ?? userCredential.user!.photoURL ?? "",
      currentStreak: 0,
      longestStreak: 0,
      masteryLevel: 0,
      totalStudyTime: 0,
      status: UserStatus.active.name,
      studyingRoomId: "",
      badges: [],
      friends: [],
      commitBoard: {
        thisYear.toString(): {
          for (int month in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
            month.toString():
                List.generate(daysInMonth(month, thisYear), (_) => 0)
        }
      },
    );

    await _db
        .collection(FirebaseConstants.users)
        .doc(userCredential.user!.uid)
        .set(newUser.toMap());
  }
}
