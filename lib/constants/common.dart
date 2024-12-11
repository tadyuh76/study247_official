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
  "grey": Color(0xFF555555),
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
  Color(0xFF9BC4E1),
  Color(0xFF82A4D7),
  Color(0xFF6386DF),
  Color(0xFF416CDB),
  Color(0xFF1F54BC),
  Color(0xFF27419D),
  Color(0xFF222C84),
  Color(0xFF2E1A80),
  Color(0xFF391468),
  Color(0xFF41074A),
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
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI4MTUyMjA3NC02ODc0LTQ0NWYtOTY2Yi02MDNiZjM2Nzg3ZTAiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTczMzg5OTM5NCwiZXhwIjoxODkxNjg3Mzk0fQ.rfWZCVYPncVwbBHQCLOkbL8SADqV_SzcqAihmaAr90E";

  // statistics
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
