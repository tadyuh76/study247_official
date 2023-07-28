// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/document.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/features/document/controllers/document_controller.dart';
import 'package:study247/features/document/screens/document_edit_screen.dart';
import 'package:study247/features/document/widgets/study_mode_dialog.dart';
import 'package:study247/features/flashcards/controllers/flashcard_list_controller.dart';

class DocumentControlScreen extends ConsumerStatefulWidget {
  final String documentId;
  const DocumentControlScreen({super.key, required this.documentId});

  @override
  ConsumerState<DocumentControlScreen> createState() =>
      _DocumentControlScreenState();
}

class _DocumentControlScreenState extends ConsumerState<DocumentControlScreen> {
  @override
  void initState() {
    super.initState();
    _setUp();
  }

  Future<void> _setUp() async {
    await ref
        .read(documentControllerProvider.notifier)
        .fetchDocumentById(widget.documentId);
    await ref.read(flashcardListControllerProvider.notifier).getFlashcardList();
  }

  void _showStudyModeDialog() {
    showDialog(context: context, builder: (context) => const StudyModeDialog());
  }

  void _practiceFlashcards() {
    context.go("/document/${widget.documentId}/flashcards");
  }

  void _editDocument(Document document) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DocumentEditScreen(document: document),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.lightGrey,
      appBar: _renderAppBar(),
      body: ref.watch(documentControllerProvider).when(
            error: (err, stk) => const AppError(),
            loading: () => const AppLoading(),
            data: (document) {
              if (document == null) return const SizedBox.shrink();

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _renderHeader(document),
                      const SizedBox(height: 20),
                      _renderFlashcardStatus(),
                      const SizedBox(height: 20),
                      _renderDocumentStatus(document),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  AppBar _renderAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Palette.lightGrey,
      titleSpacing: 0,
      automaticallyImplyLeading: true,
      actions: [
        IconButton(
          splashRadius: 25,
          onPressed: () {},
          icon: SvgPicture.asset(IconPaths.trashBin),
        )
      ],
    );
  }

  Widget _renderHeader(Document document) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          document.title,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Text(
              "Chế độ học: ",
              style: TextStyle(color: Palette.darkGrey),
            ),
            GestureDetector(
              onTap: _showStudyModeDialog,
              child: Text(
                ref.watch(documentControllerProvider).when(
                      data: (doc) => doc!.formattedStudyMode,
                      error: (err, stk) => "",
                      loading: () => "",
                    ),
                style: const TextStyle(
                  color: Palette.primary,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _renderFlashcardStatus() {
    final flashcardList =
        ref.watch(flashcardListControllerProvider).asData?.value ?? [];
    final now = DateTime.now();
    final totalFlashcard = flashcardList.length;

    final revisableFlashcard = flashcardList.fold(
        0,
        (revisable, f) => now.isAfter(DateTime.parse(f.revisableAfter))
            ? revisable + 1
            : revisable);

    return Container(
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.all(
          Radius.circular(Constants.defaultBorderRadius),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Thẻ ghi nhớ",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: CircularPercentIndicator(
              radius: 80,
              progressColor: Palette.complete,
              percent: revisableFlashcard / totalFlashcard,
              backgroundColor: Palette.lightGrey,
              animation: true,
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: 16,
              center: Text(
                totalFlashcard.toString(),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Palette.darkGrey,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      IconPaths.bookmark,
                      colorFilter: const ColorFilter.mode(
                        Palette.darkGrey,
                        BlendMode.srcIn,
                      ),
                    ),
                    const Text("Đang chờ"),
                    Text(
                      (totalFlashcard - revisableFlashcard).toString(),
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 100,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      IconPaths.academicCap,
                      colorFilter: const ColorFilter.mode(
                          Palette.complete, BlendMode.srcIn),
                    ),
                    const Text("Cần ôn tập"),
                    Text(
                      revisableFlashcard.toString(),
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: "Ôn tập",
            onTap: _practiceFlashcards,
            primary: true,
          ),
        ],
      ),
    );
  }

  Widget _renderDocumentStatus(Document document) {
    return Container(
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.all(
          Radius.circular(Constants.defaultBorderRadius),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Tài liệu gốc",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            document.text,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Palette.darkGrey),
          ),
          const Text(
            "...",
            style: TextStyle(color: Palette.darkGrey),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: "Chỉnh sửa tài liệu",
            onTap: () => _editDocument(document),
            primary: true,
          )
        ],
      ),
    );
  }
}
