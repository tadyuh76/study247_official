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

const weekdayMap = {
  "1": "M",
  "2": "T",
  "3": "W",
  "4": "T",
  "5": "F",
  "6": "S",
  "7": "S",
};

const minutesToMastery = [
  10,
  60,
  3 * 60,
  6 * 60,
  10 * 60,
  20 * 60,
  40 * 60,
  80 * 60,
  120 * 60,
  200 * 60
];
const masteryTitles = [
  "Thành viên mới",
  "Khởi đầu",
  "Sơ cấp",
  "Trung cấp",
  "Tiên tiến",
  "Thành thạo",
  "Chuyên gia",
  "Bậc thầy",
  "Kỳ cựu",
  "Sư phụ",
];

const masteryColors = [
  Color(0xFF23B0E2),
  Color(0xFF236FE2),
  Color(0xFF6023E2),
  Color(0xFF8C26DC),
  Color(0xFF9817C6),
  Color(0xFFA9129A),
  Color(0xFFD61795),
  Color(0xFFCA1460),
  Color(0xFFBD0E38),
  Color(0xFF780722),
];

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
  // common
  static const defaultPadding = 20.0;
  static const defaultBorderRadius = 16.0;
  static const appName = "Study247";
  static const appFontName = "Lexend";
  static const videoSDKToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI4MTUyMjA3NC02ODc0LTQ0NWYtOTY2Yi02MDNiZjM2Nzg3ZTAiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY4NjkyNzY0NiwiZXhwIjoxNzE4NDYzNjQ2fQ.Zt09lMfpxHeuROO4Y5881ZsCliJ5d6N5WCkFHzfiE1s";

  // message
  static const authFailedMessage = "Đăng nhập không thành công";
  static const failedMessage = "Đã có lỗi xảy ra";
  static const successMessage = "success";

  // map
  static const bannerColors = {
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

  static const masteryColors = {
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

  static const weekdayMap = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];

  // flashcard
  static const flashcardForward = ">> ";
  static const flashcardBackward = "<< ";
  static const flashcardDouble = "<> ";

  static const flashcardForwardSymbol = " → ";
  static const flashcardBackwardSymbol = " ← ";
  static const flashcardDoubleSymbol = " ↔ ";

  static const documentHeadingSymbol = "#";
}
