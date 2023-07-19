import 'package:flutter/material.dart';
import 'package:study247/core/palette.dart';

const bannerColors = {
  "blue": Palette.primary,
  "lavender": Color(0xFF7464EC),
  "pink": Color(0xFFD168B1),
  "red": Color(0xFFD35766),
  "orange": Color(0xFFD27057),
  "yellow": Color(0xFFE7B75D),
  "green": Color(0xFF3ABE87),
  "grey": Palette.darkGrey,
  "brown": Color(0xFF4B321A),
  "black": Palette.black,
};

const masteryColors = {
  1: Color(0xFF23B0E2),
  2: Color(0xFF236FE2),
  3: Color(0xFF6023E2),
  4: Color(0xFF8C26DC),
  5: Color(0xFFB023E2),
  6: Color(0xFFDE23E2),
  7: Color(0xFFE223A1),
  8: Color(0xFFE22373),
  9: Color(0xFFE22351),
  10: Color(0xFFA32D4A),
};

const tags = [
  "THCS",
  "THPT",
  "Đại học",
  "Tiếng Anh",
  "Tất cả các cấp học",
  "24/7",
  "Học với Camera",
  "Toán",
  "Lý",
  "Hóa",
  "Sinh",
  "Đại cương",
  "Trò chuyện trong giờ nghỉ",
  "Kinh tế",
  "Lập trình",
  "Văn học",
];

class Constants {
  static const defaultPadding = 20.0;
  static const appName = "Study247";
  static const appFontName = "Lexend";
  static const videoSDKToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI4MTUyMjA3NC02ODc0LTQ0NWYtOTY2Yi02MDNiZjM2Nzg3ZTAiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY4NjkyNzY0NiwiZXhwIjoxNzE4NDYzNjQ2fQ.Zt09lMfpxHeuROO4Y5881ZsCliJ5d6N5WCkFHzfiE1s";

  static const authFailedMessage = "Đăng nhập không thành công";
  static const failedMessage = "Đã có lỗi xảy ra";
  static const successMessage = "success";

  static const flashcardForward = ">> ";
  static const flashcardBackward = "<< ";
  static const flashcardDouble = "<> ";

  // static const flashcardForwardSymbol = " \u2964 ";
  static const flashcardForwardSymbol = " → ";
  // static const flashcardBackwardSymbol = " \u2962 ";
  static const flashcardBackwardSymbol = " ← ";
  // static const flashcardDoubleSymbol = " \u21cb ";
  static const flashcardDoubleSymbol = " ↔ ";

  static const documentHeadingSymbol = "#";
}
