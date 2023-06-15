import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/flashcard.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/screens/error_screen.dart';
import 'package:study247/core/shared/screens/loading_screen.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/features/flashcards/controllers/flashcard_list_controller.dart';

const defaultTextStyle = TextStyle(
  color: Palette.black,
  fontSize: 14,
  fontFamily: "Lexend",
);

class AllFlashcardsScreen extends ConsumerStatefulWidget {
  final String noteId;
  const AllFlashcardsScreen({super.key, required this.noteId});

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
      // showCustomDialog(
      //   context: context,
      //   dialog: CustomDialog(
      //     title: "Hoàn thành ôn tập!",
      //     child: Column(
      //       children: [
      //         Lottie.asset(
      //           "assets/lottie/loading_complete.json",
      //           repeat: false,
      //           animate: true,
      //           height: 200,
      //           width: 200,
      //         ),
      //         const SizedBox(height: Constants.defaultPadding),
      //         CustomButton(
      //           text: "Trở lại",
      //           primary: true,
      //           onTap: Navigator.of(context).pop,
      //         ),
      //       ],
      //     ),
      //   ),
      // );
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
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Palette.white,
                foregroundColor: Palette.black,
                centerTitle: true,
                titleSpacing: 0,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _BackgroundText(text: flashcardList.length.toString()),
                    Flexible(
                      child: Text(
                        " ${flashcardList[0].documentName}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Palette.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
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
          const SizedBox(height: Constants.defaultPadding),
          _BackgroundText(text: widget.curCard.documentName),
          const SizedBox(height: Constants.defaultPadding / 2),
          if (widget.curCard.title != "")
            Text(
              "\u2022  ${widget.curCard.title}",
              style: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 5),
          if (!showAnswer)
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 5,
              children: [
                Text(
                  "    \u2022  ${widget.curCard.front}",
                  style: defaultTextStyle,
                ),
                Text(
                  " \u2794 ",
                  style: defaultTextStyle.copyWith(
                    color: Palette.primary,
                  ),
                ),
                const _BackgroundText(text: "?")
              ],
            ),
          if (showAnswer)
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "    \u2022  ${widget.curCard.front}",
                    style: defaultTextStyle,
                  ),
                  TextSpan(
                    text: " \u2794 ",
                    style: defaultTextStyle.copyWith(color: Palette.primary),
                  ),
                  TextSpan(
                    text: widget.curCard.back,
                    style: defaultTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
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

class _BackgroundText extends StatelessWidget {
  final String text;
  const _BackgroundText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Palette.grey,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: Constants.defaultPadding / 2,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Palette.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
