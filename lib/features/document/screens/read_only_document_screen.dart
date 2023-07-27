import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/document/controllers/document_controller.dart';
import 'package:study247/features/document/screens/document_control_screen.dart';
import 'package:study247/utils/show_snack_bar.dart';

class ReadOnlyDocumentScreen extends StatefulWidget {
  final String documentText;
  const ReadOnlyDocumentScreen({super.key, required this.documentText});

  @override
  State<ReadOnlyDocumentScreen> createState() => _ReadOnlyDocumentScreenState();
}

class _ReadOnlyDocumentScreenState extends State<ReadOnlyDocumentScreen> {
  late String title;
  late String text;
  String _documentId = "";

  @override
  void initState() {
    super.initState();
    List<String> parts = widget.documentText.split("[TEXT]:");
    title = parts[0].substring("[TITLE]:".length).trim();
    text = parts[1].trim();
  }

  Future<void> _onCopyDocument(WidgetRef ref) async {
    final copiedDocumentId = await ref
        .read(documentControllerProvider.notifier)
        .copyDocument(title, text);
    setState(() {
      _documentId = copiedDocumentId;
    });
    if (mounted) {
      showSnackBar(context, "Đã sao chép tài liệu thành công");
    }
  }

  Future<void> _onViewDocument(WidgetRef ref) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentControlScreen(documentId: _documentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _renderCopyButton(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Palette.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Đây là tài liệu được chia sẻ. Hãy sao chép tài liệu này để có thể chỉnh sửa và ôn tập các thẻ ghi nhớ kèm theo.",
              style: TextStyle(fontSize: 14, color: Palette.darkGrey),
            ),
            const SizedBox(height: 20),
            Text(
              text,
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }

  Widget _renderCopyButton() {
    return Consumer(builder: (context, ref, child) {
      return GestureDetector(
        onTap: _documentId.isEmpty
            ? () => _onCopyDocument(ref)
            : () => _onViewDocument(ref),
        child: Container(
          width: double.infinity,
          margin:
              const EdgeInsets.symmetric(horizontal: Constants.defaultPadding)
                  .copyWith(bottom: 30),
          padding: const EdgeInsets.all(15),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Palette.primary,
          ),
          child: Text(
            _documentId.isEmpty ? "Sao chép tài liệu" : "Xem tài liệu đầy đủ",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Palette.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }
}
