import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/core/models/document.dart';
import 'package:study247/core/models/folder.dart';
import 'package:study247/core/models/result.dart';
import 'package:study247/features/auth/controllers/auth_controller.dart';
import 'package:study247/features/document/repositories/document_repository.dart';
import 'package:study247/features/document/screens/document_control_screen.dart';
import 'package:study247/utils/show_snack_bar.dart';

final documentControllerProvider =
    StateNotifierProvider<DocumentController, AsyncValue<Document?>>(
  (ref) => DocumentController(ref),
);

class DocumentController extends StateNotifier<AsyncValue<Document?>> {
  final Ref _ref;
  DocumentController(this._ref) : super(const AsyncData(null));

  void updateDocument(Document document) {
    state = AsyncData(document);
  }

  void editDocument(Document document) {
    state = AsyncData(document);
    _ref.read(documentRepositoryProvider).editDocument(document);
  }

  void editFolder(Folder folder) {
    _ref.read(documentRepositoryProvider).editFolder(folder);
  }

  Future<void> changeTitle(
      BuildContext context, String documentId, String newTitle) async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    final result = await _ref
        .read(documentRepositoryProvider)
        .changeTitle(userId, documentId, newTitle);

    if (result case Success()) {
      // if (mounted) {
      // showSnackBar(context, "Đã cập nhật tiêu đề tài liệu.");
      // }
    }
  }

  Future<void> updateStudyMode(String studyMode) async {
    final documentId = state.asData!.value!.id!;
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    final result = await _ref
        .read(documentRepositoryProvider)
        .updateStudyMode(userId, documentId, studyMode);
    if (result case Success()) {
      state = AsyncData(state.asData!.value!.copyWith(studyMode: studyMode));
    }
  }

  Future<void> saveDocument(
    BuildContext context,
    String documentId,
    String documentTitle,
    String documentText,
    String studyMode,
  ) async {
    final result = await _ref
        .read(documentRepositoryProvider)
        .saveDocument(documentId, documentTitle, documentText, studyMode);
    state = AsyncData(
      state.asData!.value!.copyWith(title: documentTitle, text: documentText),
    );

    if (result case Success()) {
      if (mounted) {
        showSnackBar(context, "Đã lưu.");
      }
    } else {
      if (mounted) {
        showSnackBar(context, "Đã có lỗi xảy ra trong quá trình lưu tài liệu!");
      }
    }
  }

  Future<void> createNewDocument(BuildContext context) async {
    final result =
        await _ref.read(documentRepositoryProvider).createNewDocument();

    if (result case Success(value: final document)) {
      state = AsyncData(document);
      if (context.mounted) {
        context.pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                DocumentControlScreen(documentId: document.id!),
          ),
        );
      }
    } else {
      state = const AsyncData(null);
      if (context.mounted) {
        context.pop();
        showSnackBar(context, "Đã có lỗi xảy ra trong quá trình tạo tài liệu!");
      }
    }
  }

  Future<void> createNewFolder(
    BuildContext context, {
    required String name,
    required String color,
  }) async {
    final result = await _ref
        .read(documentRepositoryProvider)
        .createNewFolder(name, color);
    if (result case Success()) {
      if (context.mounted) {
        context.pop();
        // showSnackBar(context, "Đã tạo thư mục mới!");
      }
    } else if (result case Failure()) {
      if (context.mounted) {
        context.pop();
        showSnackBar(context, "Đã có lỗi xảy ra trong quá trình tạo thư mục!");
      }
    }
  }

  Future<void> deleteFolder(BuildContext context, String folderName) async {
    final result =
        await _ref.read(documentRepositoryProvider).deleteFolder(folderName);
    if (result case Success()) {
      if (context.mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        showSnackBar(context, "Đã xoá thư mục.");
      }
    } else {
      if (context.mounted) {
        Navigator.of(context).pop();
        showSnackBar(context, "Đã có lỗi xảy ra trong quá trình xoá thư mục!");
      }
    }
  }

  Future<void> deleteDocument(BuildContext context, String documentId) async {
    final result =
        await _ref.read(documentRepositoryProvider).deleteDocument(documentId);
    if (result case Success()) {
      if (context.mounted) {
        showSnackBar(context, "Đã xoá tài liệu.");
      }
    } else {
      if (context.mounted) {
        context.pop();
        showSnackBar(context, "Đã có lỗi xảy ra trong quá trình xoá tài liệu!");
      }
    }
  }

  Future<Document?> fetchDocumentById(String documentId) async {
    final result = await _ref
        .read(documentRepositoryProvider)
        .fetchDocumentById(documentId);

    if (result case Success(value: final document)) {
      state = AsyncData(document);
      return document;
    } else if (result case Failure(:final failure)) {
      state = AsyncError(failure, StackTrace.current);
    }
    return null;
  }

  Future<void> shareDocumentToRoom(BuildContext context) async {
    final result = await _ref
        .read(documentRepositoryProvider)
        .shareDocumentToRoom(state.asData!.value!);

    if (result case Success()) {
      if (mounted) showSnackBar(context, "Đã chia sẻ tài liệu cho phòng học!");
    } else if (result case Failure(:final failure)) {
      if (mounted) showSnackBar(context, failure.toString());
    }
  }

  Future<String> copyDocument(String title, String text) async {
    final userId = _ref.read(authControllerProvider).asData!.value!.uid;
    final result = await _ref
        .read(documentRepositoryProvider)
        .copyDocument(userId, title, text);

    if (result case Success(value: final documentId)) {
      return documentId;
    }

    return "";
  }

  void reset() {
    state = const AsyncData(null);
  }
}
