// speedrun algorithm use fibonacci as spaced intervals for recall.

import 'dart:math';

import 'package:study247/features/document/widgets/study_mode_dialog.dart';

const first50FibNumbers = [
  1, // start - 0
  2,
  3,
  5, // 5m - 1st
  8,
  13,
  21, // 21m - 2nd
  34,
  55,
  89, // 1h29m - 3rd
  144,
  233,
  377, // 6h - 4th
  610,
  987,
  1597, // 1d - 5th
  2584,
  4181,
  6765, // 4d - 6th
  10946,
  17711, // 12d - 7th
  28657,
  46368, // 32d - 8th
  75025,
  121393, // 84d - 9th
  196418,
  317811, // 220d - 10th
  514229,
  832040,
  1346269,
  2178309,
  3524578,
  5702887,
  9227465,
  14930352,
  24157817,
  39088169,
  63245986,
  102334155,
  165580141,
  267914296,
  433494437,
  701408733,
  1134903170,
  1836311903,
  2971215073,
  4807526976,
  7778742049,
  12586269025,
  20365011074,
];

const aDayInMinutes = 60 * 24;

const hardInterval = 1.2;
const easyBonus = 1.3;

const defaultHardInterval = 8.0;
const defaultHardIntervals = [8.0, 15, 60 * 24, 4 * 60 * 24];
const defaultGoodInterval = 15.0;
const defaultEasyInterval = 4 * 24 * 60.0; // 4 days

class Flashcard {
  String? id;
  final String front;
  final String back;
  final String title;
  final String documentName;
  final String type;
  final String revisableAfter;
  final double ease;
  final double currentInterval;
  final double priorityRate;
  final int level;

  String get formattedStudyMode =>
      type == StudyMode.longterm.name ? "Ghi nhớ dài hạn" : "Ôn tập nước rút";

  int get nextLevelSpeedrun {
    // 6 first steps have an interval of 3 levels to avoid annoying
    final jumpStep = (level < 3 * 6) ? 3 : 2;
    final newFlashcardLevel = level + jumpStep;
    return newFlashcardLevel;
  }

  String get nextRevisableTimeSpeedrun {
    final newTime = DateTime.now().add(
      Duration(
        minutes: first50FibNumbers[nextLevelSpeedrun] ~/ priorityRate,
        seconds: 1,
        // the algorithm's comparison is buggy, added 1s for accurate result.
      ),
    );
    return newTime.toString();
  }

  int get _delay => max(
      0, DateTime.now().difference(DateTime.parse(revisableAfter)).inMinutes);

  bool get notInRevisableTime =>
      DateTime.now().isBefore(DateTime.parse(revisableAfter));

  double get nextIntervalHard {
    if (level == 0) return defaultHardInterval;
    final delayFactor = _delay / 4;

    return max(
      currentInterval + aDayInMinutes,
      (currentInterval + delayFactor) * hardInterval,
    );
  }

  double get nextIntervalGood {
    if (level == 0) return defaultGoodInterval;
    final delayFactor = _delay / 2;

    return max(
      nextIntervalHard + aDayInMinutes,
      (currentInterval + delayFactor) * ease,
    );
  }

  double get nextIntervalEasy {
    if (level == 0) return defaultEasyInterval;
    final delayFactor = _delay;

    return max(
      nextIntervalGood + aDayInMinutes,
      (currentInterval + delayFactor) * ease * easyBonus,
    );
  }

  String getRevisableTimeLongterm(double time) {
    return DateTime.now()
        .add(Duration(minutes: time ~/ priorityRate, seconds: 1))
        .toString();
  }

  String getFormattedRevisableTime(String time) {
    final duration = DateTime.parse(time).difference(DateTime.now());
    if (duration.inMinutes < 60) return "${duration.inMinutes}m";
    if (duration.inHours < 24) return "${duration.inHours}h";
    return "${duration.inDays}d";
  }

  Flashcard({
    this.id,
    required this.front,
    required this.back,
    required this.title,
    required this.documentName,
    required this.type,
    required this.revisableAfter,
    required this.ease,
    required this.currentInterval,
    required this.priorityRate,
    required this.level,
  });

  Flashcard copyWith({
    String? id,
    String? front,
    String? back,
    String? title,
    String? documentName,
    String? type,
    String? revisableAfter,
    double? ease,
    double? currentInterval,
    double? priorityRate,
    int? level,
  }) {
    return Flashcard(
      id: id ?? this.id,
      front: front ?? this.front,
      back: back ?? this.back,
      title: title ?? this.title,
      documentName: documentName ?? this.documentName,
      type: type ?? this.type,
      revisableAfter: revisableAfter ?? this.revisableAfter,
      ease: ease ?? this.ease,
      currentInterval: currentInterval ?? this.currentInterval,
      priorityRate: priorityRate ?? this.priorityRate,
      level: level ?? this.level,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'front': front,
      'back': back,
      'title': title,
      'documentName': documentName,
      'type': type,
      'revisableAfter': revisableAfter,
      'ease': ease,
      'currentInterval': currentInterval,
      'priorityRate': priorityRate,
      'level': level,
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      front: map['front'] ?? '',
      back: map['back'] ?? '',
      title: map['title'] ?? '',
      documentName: map['documentName'] ?? '',
      type: map['type'] ?? '',
      revisableAfter: map['revisableAfter'] ?? '',
      ease: map['ease']?.toDouble() ?? 0.0,
      currentInterval: map['currentInterval']?.toDouble() ?? 0.0,
      priorityRate: map['priorityRate']?.toDouble() ?? 0.0,
      level: map['level']?.toInt() ?? 0,
    );
  }

  @override
  String toString() {
    return 'Flashcard(id: $id, front: $front, back: $back, title: $title, documentName: $documentName, type: $type, revisableAfter: $revisableAfter, ease: $ease, currentInterval: $currentInterval, priorityRate: $priorityRate, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Flashcard &&
        other.id == id &&
        other.front == front &&
        other.back == back &&
        other.title == title &&
        other.documentName == documentName &&
        other.type == type &&
        other.revisableAfter == revisableAfter &&
        other.ease == ease &&
        other.currentInterval == currentInterval &&
        other.priorityRate == priorityRate &&
        other.level == level;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        front.hashCode ^
        back.hashCode ^
        title.hashCode ^
        documentName.hashCode ^
        type.hashCode ^
        revisableAfter.hashCode ^
        ease.hashCode ^
        currentInterval.hashCode ^
        priorityRate.hashCode ^
        level.hashCode;
  }
}
