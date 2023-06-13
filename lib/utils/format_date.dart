String twoDigits(int n) => n.toString().padLeft(2, "0");
String formatDate(String dateStr) {
  final date = DateTime.parse(dateStr);
  final now = DateTime.now();

  if (date.day != now.day && date.month != now.month && date.year != now.year) {
    final day = twoDigits(date.day);
    final month = twoDigits(date.month);
    return "$day/$month";
  }

  final hour = twoDigits(date.hour);
  final minute = twoDigits(date.minute);
  return "$hour:$minute";
}
