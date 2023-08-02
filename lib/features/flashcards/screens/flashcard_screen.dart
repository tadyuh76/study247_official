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
import 'package:study247/features/flashcards/widgets/flashcard_option.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  const FlashcardScreen({super.key});

  @override
  ConsumerState<FlashcardScreen> createState() => _AllFlashcardsScreenState();
}

class _AllFlashcardsScreenState extends ConsumerState<FlashcardScreen> {
  final _pageController = PageController();

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _nextPage() async {
    final curPage = _pageController.page;
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    final newPage = _pageController.page;
    final complete = curPage == newPage;

    if (complete && mounted) {
      showDialog(
        context: context,
        builder: (context) => const CompleteDiaglog(),
      );
    }
  }

  // longterm
  void _onAgain(Flashcard flashcard) {
    _nextPage();
    ref.read(flashcardListControllerProvider.notifier).recallAgain(flashcard);
  }

  void _onHard(Flashcard flashcard) {
    _nextPage();
    ref.read(flashcardListControllerProvider.notifier).recallHard(flashcard);
  }

  void _onMedium(Flashcard flashcard) {
    _nextPage();
    ref.read(flashcardListControllerProvider.notifier).recallGood(flashcard);
  }

  void _onEasy(Flashcard flashcard) {
    _nextPage();
    ref.read(flashcardListControllerProvider.notifier).recallEasy(flashcard);
  }

  // speedrun
  void _onOK(Flashcard flashcard) {
    _nextPage();
    ref.read(flashcardListControllerProvider.notifier).recallOK(flashcard);
  }

  void _onNotOK(Flashcard flashcard) {
    _nextPage();
    ref.read(flashcardListControllerProvider.notifier).recallNotOK(flashcard);
  }

  @override
  Widget build(BuildContext context) {
    return ref.read(flashcardListControllerProvider).when(
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

            final revisableCards = flashcardList
                .where((flashcard) => !flashcard.notInRevisableTime)
                .toList();

            revisableCards.sort((a, b) => DateTime.parse(a.revisableAfter)
                .compareTo(DateTime.parse(b.revisableAfter)));

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
                itemCount: revisableCards.length,
                itemBuilder: (context, index) => _FlashcardTab(
                  curCard: revisableCards[index],
                  nextPage: () => _nextPage(),
                  onEasy: () => _onEasy(revisableCards[index]),
                  onHard: () => _onHard(revisableCards[index]),
                  onGood: () => _onMedium(revisableCards[index]),
                  onAgain: () => _onAgain(revisableCards[index]),
                  onOK: () => _onOK(revisableCards[index]),
                  onNotOK: () => _onNotOK(revisableCards[index]),
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
          Text(
            widget.curCard.formattedStudyMode,
            style: const TextStyle(fontSize: 14, color: Palette.darkGrey),
          ),
          Text(
            widget.curCard.documentName,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
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
    final curCard = widget.curCard;

    final hardInterval = curCard.getFormattedRevisableTime(
      curCard.getRevisableTimeLongterm(curCard.nextIntervalHard),
    );
    final goodInterval = curCard.getFormattedRevisableTime(
      curCard.getRevisableTimeLongterm(curCard.nextIntervalGood),
    );
    final easyInterval = curCard.getFormattedRevisableTime(
      curCard.getRevisableTimeLongterm(curCard.nextIntervalEasy),
    );

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FlashcardOption(
              text: "Xem lại",
              interval: "1m",
              onTap: widget.onAgain,
              color: bannerColors['black'],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FlashcardOption(
              text: "Khó",
              interval: hardInterval,
              onTap: widget.onHard,
              color: bannerColors["red"]!,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FlashcardOption(
              text: "Thường",
              interval: goodInterval,
              onTap: widget.onGood,
              color: bannerColors["yellow"]!,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FlashcardOption(
              text: "Dễ",
              interval: easyInterval,
              onTap: widget.onEasy,
              color: bannerColors['blue']!,
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderSpeedrunActions() {
    final interval = widget.curCard
        .getFormattedRevisableTime(widget.curCard.nextRevisableTimeSpeedrun);

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: FlashcardOption(
              text: "Cần xem lại",
              interval: "1p",
              onTap: widget.onNotOK,
              color: bannerColors['red'],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: FlashcardOption(
              text: "Tiếp tục",
              interval: interval,
              onTap: widget.onOK,
              color: bannerColors['blue'],
            ),
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
