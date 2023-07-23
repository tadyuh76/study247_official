import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/models/result.dart';

final offlineFileRepositoryProvider =
    Provider((ref) => OfflineFilerepository());

class OfflineFilerepository {
  Future<Result<PlatformFile, Exception>> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
        allowMultiple: false,
        withData: true,
      );
      if (result == null) return Failure(Exception("Không thể tải tệp"));

      final file = result.files.first;
      final fileBytes = file.bytes;
      if (fileBytes == null) return Failure(Exception("Không thể tải tệp"));

      return Success(file);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
