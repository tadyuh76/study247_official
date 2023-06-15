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
  "Đại cương"
];

class Constants {
  static const double defaultPadding = 20;
  static const appName = "Study247";
  static const appFontName = "Lexend";

  static const authFailedMessage = "Đăng nhập không thành công";
  static const failedMessage = "Đã có lỗi xảy ra";
  static const successMessage = "success";
}
