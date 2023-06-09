import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:study247/core/constants/firebase.dart';
import 'package:study247/core/constants/shared.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/providers/firebase_providers.dart';

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
        final newUser = UserModel(
          uid: userCredential.user!.uid,
          displayName: userCredential.user!.displayName ?? "",
          email: userCredential.user!.email ?? "",
          photoURL: userCredential.user!.photoURL ?? "",
        );
        _db
            .collection(FirebaseConstants.users)
            .doc(userCredential.user!.uid)
            .set(newUser.toMap());
      }

      return Success(userCredential);
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
}
