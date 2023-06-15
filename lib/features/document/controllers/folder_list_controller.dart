import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/folder.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';

final folderListControllerProvider = StreamProvider(
  (ref) => FolderListController(ref).getFolderList(),
);

class FolderListController {
  final Ref _ref;
  FolderListController(this._ref);

  Stream<List<Folder>> getFolderList() {
    final db = _ref.read(firestoreProvider);
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;

    final snapshots = db
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.folders)
        .snapshots();
    final folderListStream = snapshots.map(
      (event) => event.docs.map((e) => Folder.fromMap(e.data())).toList(),
    );
    return folderListStream;
  }
}
