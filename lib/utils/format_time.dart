String twoDigits(int duration) => duration.toString().padLeft(2, "0");

String formatTime(int timeInSeconds) {
  final duration = Duration(seconds: timeInSeconds);
  String hours = twoDigits(duration.inHours);
  String minutes = twoDigits(duration.inMinutes.remainder(60));
  String seconds = twoDigits(duration.inSeconds.remainder(60));
  return "$hours:$minutes:$seconds";
}
