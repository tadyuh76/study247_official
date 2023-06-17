import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/file.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/core/providers/firebase_providers.dart';
import 'package:study247/features/room/controllers/room_controller.dart';

final fileRepositoryProvider = Provider((ref) => FileRepository(ref));

class FileRepository {
  final Ref _ref;
  FileRepository(this._ref);

  Future<Result<File, Exception>> pickFile({bool solo = false}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
        allowMultiple: false,
        withData: true,
      );
      if (result == null) return Failure(Exception("Không thể tải tệp"));

      final file = result.files.first;
      final fileBytes = file.bytes;
      if (fileBytes == null) return Failure(Exception("Không thể tải tệp"));

      final roomId = _ref.read(roomControllerProvider).asData?.value?.id;
      final storage = _ref.read(storageProvider);
      // final db = _ref.read(firestoreProvider);

      // upload to Firebase and get download URL
      late Reference fileDir;
      if (solo) {
        fileDir = storage.ref("/files/solo/${file.name}");
      } else {
        fileDir = storage.ref('/files/$roomId/${file.name}');
      }
      final res = await fileDir.putData(fileBytes);
      final fileUrl = await res.ref.getDownloadURL();

      // db
      //     .collection(FirebaseConstants.rooms)
      //     .doc(roomId)
      //     .update({"fileUrl": fileUrl, "fileType": file.extension});

      return Success(File(type: file.extension!, url: fileUrl));
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  Future<Result<String, Exception>> removeFile() async {
    try {
      // final currentRoomId = _ref.read(roomControllerProvider).asData!.value!.id;
      // final db = _ref.read(firestoreProvider);
      // await db.collection(FirebaseConstants.rooms).doc(currentRoomId).update({
      //   "fileUrl": "",
      //   "fileType": "",
      // });
      return const Success(Constants.successMessage);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
