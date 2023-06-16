import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/flashcard.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/screens/error_screen.dart';
import 'package:study247/core/shared/screens/loading_screen.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/features/flashcards/controllers/flashcard_list_controller.dart';
import 'package:study247/features/flashcards/widgets/complete_dialog.dart';

const defaultTextStyle = TextStyle(
  color: Palette.black,
  fontSize: 14,
  fontFamily: "Lexend",
);

class AllFlashcardsScreen extends ConsumerStatefulWidget {
  const AllFlashcardsScreen({super.key});

  @override
  ConsumerState<AllFlashcardsScreen> createState() =>
      _AllFlashcardsScreenState();
}

class _AllFlashcardsScreenState extends ConsumerState<AllFlashcardsScreen> {
  final _pageController = PageController();

  void _nextPage() async {
    final curPage = _pageController.page;
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    final newPage = _pageController.page;
    if (curPage == newPage && mounted) {
      // TODO: implement saving new flashcards
      showDialog(
        context: context,
        builder: (context) => CompleteDiaglog(hideDialog: context.pop),
      );
    }
  }

  void onEasy() {
    _nextPage();
    // TODO: implement next page algorithm
  }

  void onHard() {
    _nextPage();
    // TODO: implement next page algorithm
  }

  void onNeedRevise() {
    _nextPage();
    // TODO: implement next page algorithm
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(flashcardListControllerProvider).when(
          error: (err, stk) => const ErrorScreen(),
          loading: () => const LoadingScreen(),
          data: (flashcardList) {
            if (flashcardList.isEmpty) {
              return const Scaffold(
                body: Center(
                  child: Text("Trống"),
                ),
              );
            }

            flashcardList.shuffle();
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Palette.white,
                foregroundColor: Palette.black,
                centerTitle: true,
                titleSpacing: 0,
                title: const Text("Ôn tập Flashcard"),
              ),
              body: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: flashcardList.length,
                itemBuilder: (context, index) => _FlashcardPage(
                  curCard: flashcardList[index],
                  nextPage: () => _nextPage(),
                  onEasy: onEasy,
                  onHard: onHard,
                  onNeedRevise: onNeedRevise,
                ),
              ),
            );
          },
        );
  }
}

class _FlashcardPage extends StatefulWidget {
  final Flashcard curCard;
  final VoidCallback nextPage;
  final VoidCallback onEasy;
  final VoidCallback onHard;
  final VoidCallback onNeedRevise;
  const _FlashcardPage({
    required this.curCard,
    required this.nextPage,
    required this.onEasy,
    required this.onHard,
    required this.onNeedRevise,
  });

  @override
  State<_FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<_FlashcardPage> {
  bool showAnswer = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Đang ôn tài liệu:",
            style: TextStyle(fontSize: 14, color: Palette.darkGrey),
          ),
          Text(
            widget.curCard.documentName,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: Constants.defaultPadding),
          const SizedBox(height: Constants.defaultPadding),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Constants.defaultPadding,
              ),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Palette.lightGrey,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.grey,
                      offset: Offset(4, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(Constants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.curCard.title,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Palette.darkGrey),
                    ),
                    const SizedBox(height: Constants.defaultPadding * 2),
                    Text(
                      widget.curCard.front,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: Constants.defaultPadding),
                    Text(
                      showAnswer ? widget.curCard.back : "...",
                      style: TextStyle(
                        fontSize: 20,
                        color: showAnswer ? Palette.black : Palette.darkGrey,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: Constants.defaultPadding),
          if (!showAnswer)
            CustomButton(
              text: "Hiện đáp án",
              onTap: () => setState(() => showAnswer = true),
            ),
          if (showAnswer)
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Tiếp tục",
                      onTap: widget.onEasy,
                    ),
                  ),
                  // const SizedBox(width: 5),
                  // Expanded(
                  //   child: CustomButton(
                  //
                  //     text: "Khó",
                  //     onTap: widget.onHard,
                  //     color: bannerColors["red"],
                  //     primary: true,
                  //   ),
                  // ),
                  // const SizedBox(width: 5),
                  // CustomButton(
                  //
                  //   text: "Cần xem lại",
                  //   onTap: widget.onNeedRevise,
                  //   color: bannerColors["blue"],
                  //   primary: true,
                  // ),
                ],
              ),
            ),
          const SizedBox(height: Constants.defaultPadding)
        ],
      ),
    );
  }
}
