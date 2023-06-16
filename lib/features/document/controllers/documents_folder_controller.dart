import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/firebase.dart';
import 'package:study247/core/models/document.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';

final documentfolderControllerProvider =
    StreamProvider.family<List<Document>, String>(
  (ref, folderName) => DocumentListController(ref).getDocumentList(folderName),
);

class DocumentListController {
  final Ref _ref;
  DocumentListController(this._ref);

  Stream<List<Document>> getDocumentList(String folderName) {
    final db = _ref.read(firestoreProvider);
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;

    final snapshots = db
        .collection(FirebaseConstants.users)
        .doc(userId)
        .collection(FirebaseConstants.documents)
        .where("folderName", isEqualTo: folderName)
        .snapshots();
    final documentListStream = snapshots.map(
      (event) => event.docs.map((e) => Document.fromMap(e.data())).toList(),
    );
    return documentListStream;
  }
}
