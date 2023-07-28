import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/flashcard.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/screens/error_screen.dart';
import 'package:study247/core/shared/screens/loading_screen.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/features/document/widgets/study_mode_dialog.dart';
import 'package:study247/features/flashcards/controllers/flashcard_list_controller.dart';
import 'package:study247/features/flashcards/widgets/complete_dialog.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  const FlashcardScreen({super.key});

  @override
  ConsumerState<FlashcardScreen> createState() => _AllFlashcardsScreenState();
}

class _AllFlashcardsScreenState extends ConsumerState<FlashcardScreen> {
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
        builder: (context) => const CompleteDiaglog(),
      );
    }
  }

  void _onAgain(Flashcard flashcard) {}

  void _onHard(Flashcard flashcard) {
    _nextPage();
    // PushNotificationService().showNotification(
    //   id: Random().nextInt(762005),
    //   title: flashcard.title,
    //   body: flashcard.front,
    //   duration: Duration(
    //     minutes: int.parse(
    //       (flashcard.currentInterval * 60 * 1.5).toStringAsFixed(0),
    //     ),
    //   ),
    // );
  }

  void _onMedium(Flashcard flashcard) {
    _nextPage();
    // PushNotificationService().showNotification(
    //   id: Random().nextInt(762005),
    //   title: flashcard.title,
    //   body: flashcard.front,
    //   duration: Duration(
    //     minutes: int.parse(
    //       (flashcard.currentInterval * 60 * 1).toStringAsFixed(0),
    //     ),
    //   ),
    // );
  }

  void _onEasy(Flashcard flashcard) {
    _nextPage();
    // PushNotificationService().showNotification(
    //   id: Random().nextInt(762005),
    //   title: flashcard.title,
    //   body: flashcard.front,
    //   duration: Duration(
    //     minutes: int.parse(
    //       (flashcard.currentInterval * 60 * 1.3).toStringAsFixed(0),
    //     ),
    //   ),
    // );
  }

  void _onOK(Flashcard flashcard) {}

  void _onNotOK(Flashcard flashcard) {}

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
                itemBuilder: (context, index) => _FlashcardTab(
                  curCard: flashcardList[index],
                  nextPage: () => _nextPage(),
                  onEasy: () => _onEasy(flashcardList[index]),
                  onHard: () => _onHard(flashcardList[index]),
                  onGood: () => _onMedium(flashcardList[index]),
                  onAgain: () => _onAgain(flashcardList[index]),
                  onOK: () => _onOK(flashcardList[index]),
                  onNotOK: () => _onNotOK(flashcardList[index]),
                ),
              ),
            );
          },
        );
  }
}

class _FlashcardTab extends StatefulWidget {
  final Flashcard curCard;
  final VoidCallback nextPage;
  final VoidCallback onEasy;
  final VoidCallback onHard;
  final VoidCallback onGood;
  final VoidCallback onAgain;
  final VoidCallback onOK;
  final VoidCallback onNotOK;

  const _FlashcardTab({
    required this.curCard,
    required this.nextPage,
    required this.onEasy,
    required this.onHard,
    required this.onGood,
    required this.onAgain,
    required this.onOK,
    required this.onNotOK,
  });

  @override
  State<_FlashcardTab> createState() => _FlashcardTabState();
}

class _FlashcardTabState extends State<_FlashcardTab> {
  bool showAnswer = false;

  void _showAnswer() {
    setState(() => showAnswer = true);
  }

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
          _renderFlashcard(),
          const SizedBox(height: Constants.defaultPadding),
          if (!showAnswer)
            CustomButton(
              text: "Hiện đáp án",
              onTap: _showAnswer,
            ),
          if (showAnswer && widget.curCard.type == StudyMode.longterm.name)
            _renderLongtermActions(),
          if (showAnswer && widget.curCard.type == StudyMode.speedrun.name)
            _renderSpeedrunActions(),
          const SizedBox(height: Constants.defaultPadding)
        ],
      ),
    );
  }

  Widget _renderLongtermActions() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            text: "Xem lại",
            onTap: widget.onAgain,
            color: bannerColors['black'],
            primary: true,
          ),
          CustomButton(
            text: "Khó",
            onTap: widget.onHard,
            color: bannerColors["red"]!,
            primary: true,
          ),
          CustomButton(
            text: "Ổn",
            onTap: widget.onGood,
            color: bannerColors["yellow"]!,
            primary: true,
          ),
          CustomButton(
            text: "Dễ",
            onTap: widget.onEasy,
            primary: true,
            color: bannerColors['blue']!,
          ),
        ],
      ),
    );
  }

  Widget _renderSpeedrunActions() {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            text: "Cần xem lại",
            onTap: widget.onNotOK,
            color: bannerColors['red'],
            primary: true,
          ),
          CustomButton(
            text: "Tiếp tục",
            onTap: widget.onNotOK,
            color: bannerColors['blue'],
            primary: true,
          ),
        ],
      ),
    );
  }

  Widget _renderFlashcard() {
    return Expanded(
      child: GestureDetector(
        onTap: _showAnswer,
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
                    color: Palette.darkGrey,
                  ),
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
    );
  }
}
