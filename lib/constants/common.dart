import 'package:flutter/material.dart';
import 'package:study247/core/palette.dart';

const bannerColors = {
  "blue": Palette.primary,
  "lavender": Color(0xFF7464EC),
  "pink": Color(0xFFD168B1),
  "red": Color(0xFFD35766),
  "orange": Color(0xFFD27057),
  "yellow": Palette.warning,
  "green": Color(0xFF3ABE87),
  "grey": Palette.darkGrey,
  "brown": Color(0xFF4B321A),
  "black": Palette.black,
};

const weekdayMap = ["T2", "T3", "T4", "T5", "T6", "T7", "CN"];

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
  "Khởi đầu",
  "Sơ cấp",
  "Trung cấp",
  "Nâng cao",
  "Ham học",
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
  "24/7",
  "Học với Camera",
  "Trò chuyện trong giờ nghỉ",
  "THCS",
  "THPT",
  "Đại học",
  "Tất cả các cấp học",
  "Toán",
  "Lý",
  "Hóa",
  "Sinh",
  "Văn học",
  "Tiếng Anh",
  "Đại cương",
  "Kinh tế",
  "Lập trình",
];

class Constants {
  // common
  static const defaultPadding = 20.0;
  static const defaultBorderRadius = 16.0;
  static const appName = "Study247";
  static const appFontName = "Lexend";
  static const videoSDKToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI4MTUyMjA3NC02ODc0LTQ0NWYtOTY2Yi02MDNiZjM2Nzg3ZTAiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY4NjkyNzY0NiwiZXhwIjoxNzE4NDYzNjQ2fQ.Zt09lMfpxHeuROO4Y5881ZsCliJ5d6N5WCkFHzfiE1s";

  // statistics
  static const numberOfMasteryLevels = 10;
  static const minutesToMaxOpacityCalendar = 120;
  static const minutesPerDayToContinueStreak = 15;

  // message
  static const authFailedMessage = "Đăng nhập không thành công";
  static const failedMessage = "Đã có lỗi xảy ra";
  static const successMessage = "success";

  // flashcard
  static const flashcardForward = ">> ";
  static const flashcardBackward = "<< ";
  static const flashcardDouble = "<> ";

  static const flashcardForwardSymbol = " → ";
  static const flashcardBackwardSymbol = " ← ";
  static const flashcardDoubleSymbol = " ↔ ";

  static const documentHeadingSymbol = "#";
}
