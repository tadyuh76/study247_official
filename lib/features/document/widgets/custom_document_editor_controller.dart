import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class CustomDocumentEditorController extends TextEditingController {
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
