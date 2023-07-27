import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/document.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/document/controllers/document_controller.dart';
import 'package:study247/features/flashcards/controllers/flashcard_list_controller.dart';
import 'package:study247/features/flashcards/screens/flashcard_screen.dart';
import 'package:study247/features/room/controllers/room_controller.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dialogs/leave_dialog.dart';
import 'package:study247/utils/show_snack_bar.dart';
import 'package:study247/utils/unfocus.dart';

class DocumentEditScreen extends ConsumerStatefulWidget {
  final Document document;
  const DocumentEditScreen({super.key, required this.document});

  @override
  ConsumerState<DocumentEditScreen> createState() => _DocumentEditScreenState();
}

class _DocumentEditScreenState extends ConsumerState<DocumentEditScreen> {
  final _titleController = TextEditingController();
  final _documentController = _DocCustomController();
  bool saved = true;
  bool saving = false;
  int _flashcardsCreated = 0;

  @override
  void initState() {
    super.initState();
    _setUpDocument();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _documentController.dispose();
  }

  Future<void> _setUpDocument() async {
    _titleController.text = widget.document.title;
    _documentController.text = widget.document.text;

    _flashcardsCreated = await ref
        .read(flashcardListControllerProvider.notifier)
        .getFlashcardList();
    setState(() {});
  }

  void _onTitleChanged(String newTitle) {
    final previousSelection = _titleController.selection;
    _titleController.text = newTitle;
    _titleController.selection = previousSelection;

    if (saved) setState(() => saved = false);
  }

  void _onDocumentChanged(String text) {
    final previousSelection = _documentController.selection;
    _documentController.text = text;
    _documentController.selection = previousSelection;

    if (saved) setState(() => saved = false);
  }

  Future<void> _onSaved() async {
    setState(() => saving = true);
    final documentText = _documentController.text.trim();
    final documentTitle = _titleController.text.trim();
    await ref.read(documentControllerProvider.notifier).saveDocument(
        context, widget.document.id!, documentTitle, documentText);
    _flashcardsCreated = await ref
        .watch(flashcardListControllerProvider.notifier)
        .getFlashcardList();

    setState(() {
      saved = true;
      saving = false;
    });
    // }
  }

  Future<void> _shareNote() async {
    final roomId = ref.read(roomControllerProvider).asData?.value?.id;
    if (roomId == null) {
      showSnackBar(context, "Bạn cần ở trong một phòng học mới có thể chia sẻ");
      return;
    }

    ref.read(documentControllerProvider.notifier).shareDocumentToRoom(context);
  }

  Future<bool> _onExit() async {
    if (saved) return true;

    showDialog(
      context: context,
      builder: (context) => LeaveDialog(
        onAccept: () async {
          await _onSaved();
          if (mounted) {
            context
              ..pop()
              ..pop();
          }
        },
        title: "Thoát chỉnh sửa",
        child: const Text(
          "Bạn có thay đổi chưa được lưu. Lưu chúng ?",
          style: TextStyle(color: Palette.black, fontSize: 14),
        ),
      ),
    );

    return false;
  }

  void _onDelete() {
    showDialog(
      context: context,
      builder: (context) => LeaveDialog(
        title: "Xóa tài liệu này?",
        onAccept: _deleteDocument,
        child: const Text("Tài liệu sau khi xoá sẽ không thể khôi phục."),
      ),
    );
  }

  void _deleteDocument() {
    ref
        .read(documentControllerProvider.notifier)
        .deleteDocument(context, widget.document.id!);
    if (mounted) {
      context
        ..pop()
        ..pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onExit,
      child: Unfocus(
        child: Scaffold(
          appBar: _renderAppBar(),
          body: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.defaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _renderTitleEditor(),
                    _renderLastEdit(),
                    const SizedBox(height: Constants.defaultPadding / 2),
                    _renderDocumentEditor(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextField _renderDocumentEditor() {
    return TextField(
      maxLengthEnforcement: MaxLengthEnforcement.none,
      maxLength: TextField.noMaxLength,
      controller: _documentController,
      maxLines: null,
      onChanged: _onDocumentChanged,
      cursorColor: Palette.primary,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintStyle: TextStyle(color: Palette.darkGrey),
        hintText: "Nhập nội dung...",
      ),
      style: const TextStyle(
        height: 1.5,
        color: Palette.black,
        // fontWeight: FontWeight.w300,
        fontSize: 14,
      ),
    );
  }

  TextField _renderTitleEditor() {
    return TextField(
      maxLines: null,
      controller: _titleController,
      onChanged: _onTitleChanged,
      style: const TextStyle(
        color: Palette.black,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      decoration: const InputDecoration(
        hintText: "Nhập tiêu đề...",
        hintStyle: TextStyle(color: Palette.darkGrey),
        border: InputBorder.none,
      ),
    );
  }

  Widget _renderLastEdit() {
    return Text(
      ref.watch(documentControllerProvider).asData?.value?.formattedLastEdit ??
          "",
      style: const TextStyle(
        fontSize: 12,
        color: Palette.darkGrey,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  AppBar _renderAppBar() {
    return AppBar(
      titleSpacing: 0,
      backgroundColor: Palette.white,
      elevation: 0,
      foregroundColor: Palette.black,
      actions: [
        ..._renderDefaultLeading(),
        if (saving)
          IconButton(
            onPressed: () {},
            icon: const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        if (!saved && !saving)
          IconButton(
            splashRadius: 24,
            onPressed: _onSaved,
            icon: const Icon(
              Icons.check,
              color: Palette.primary,
              size: 24,
            ),
          ),
      ],
    );
  }

  List<Widget> _renderDefaultLeading() {
    return [
      IconButton(
        splashRadius: 24,
        onPressed: _onDelete,
        icon: SvgPicture.asset(
          IconPaths.trashBin,
          height: 24,
          width: 24,
        ),
      ),
      IconButton(
        splashRadius: 24,
        onPressed: _shareNote,
        icon: SvgPicture.asset(
          IconPaths.share,
          height: 24,
          width: 24,
        ),
      ),
      Padding(
        padding:
            const EdgeInsets.only(left: 5, right: Constants.defaultPadding),
        child: GestureDetector(
          onTap: _flashcardsCreated == 0
              ? () =>
                  showSnackBar(context, "Không tìm thấy flashcard để ôn tập")
              : () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const FlashcardScreen(),
                    ),
                  ),
          child: SizedBox(
            width: 24 + 10,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  IconPaths.flashcards,
                  width: 24,
                  height: 24,
                ),
                if (_flashcardsCreated != 0)
                  _renderFlashcardsBadge(_flashcardsCreated)
              ],
            ),
          ),
        ),
      ),
    ];
  }

  Widget _renderFlashcardsBadge(int flashcardCreated) {
    return Positioned(
      top: 10,
      right: 0,
      child: Container(
        width: 16,
        height: 16,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Palette.primary,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Text(
          "$flashcardCreated",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Palette.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _DocCustomController extends TextEditingController {
  bool _isHeadline(String line) {
    return line.contains("#");
  }

  TextSpan _renderHeadline(String line, TextStyle style) {
    return TextSpan(
      text: "$line\n",
      style: style.copyWith(fontWeight: FontWeight.w500),
    );
  }

  bool _isFlashcard(String line) {
    return line.contains(Constants.flashcardForward) ||
        line.contains(Constants.flashcardBackward) ||
        line.contains(Constants.flashcardDouble);
  }

  String _getFlashcardType(String line) {
    if (line.contains(Constants.flashcardForward)) {
      return Constants.flashcardForward;
    } else if (line.contains(Constants.flashcardBackward)) {
      return Constants.flashcardBackward;
    } else {
      return Constants.flashcardDouble;
    }
  }

  TextSpan _renderFlashcard(String line, TextStyle style) {
    final cardType = _getFlashcardType(line);
    final cardSides = line.split(cardType);
    final symbol = cardType == Constants.flashcardForward
        ? Constants.flashcardForwardSymbol
        : cardType == Constants.flashcardBackward
            ? Constants.flashcardBackwardSymbol
            : Constants.flashcardDoubleSymbol;
    final frontSideText = cardSides[0];
    final backSideText = cardSides[1];

    return TextSpan(
      children: [
        TextSpan(text: "$frontSideText ", style: style),
        TextSpan(
          text: symbol.trim(),
          style: style.copyWith(
            color: Palette.primary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextSpan(text: " $backSideText\n", style: style),
      ],
    );
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final texts = value.text.split("\n").map((line) {
      if (_isHeadline(line)) return _renderHeadline(line, style!);
      if (_isFlashcard(line)) return _renderFlashcard(line, style!);

      return TextSpan(text: "$line\n", style: style);
    });

    return TextSpan(style: style, children: texts.toList());
  }
}
