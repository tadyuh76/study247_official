import 'package:study247/constants/common.dart';

final badgeAssetPaths = {
  '1_focus': 'assets/icons/badges/1_focus.svg',
  '2_focus': 'assets/icons/badges/2_focus.svg',
  '3_focus': 'assets/icons/badges/3_focus.svg',
  '4_focus': 'assets/icons/badges/4_focus.svg',
  '5_focus': 'assets/icons/badges/5_focus.svg',
  '1_hardwork': 'assets/icons/badges/1_hardwork.svg',
  '2_hardwork': 'assets/icons/badges/2_hardwork.svg',
  '3_hardwork': 'assets/icons/badges/3_hardwork.svg',
  '4_hardwork': 'assets/icons/badges/4_hardwork.svg',
  '5_hardwork': 'assets/icons/badges/5_hardwork.svg',
  '1_persevere': 'assets/icons/badges/1_persevere.svg',
  '2_persevere': 'assets/icons/badges/2_persevere.svg',
  '3_persevere': 'assets/icons/badges/3_persevere.svg',
  '4_persevere': 'assets/icons/badges/4_persevere.svg',
  '5_persevere': 'assets/icons/badges/5_persevere.svg',
  '1_discipline': 'assets/icons/badges/1_discipline.svg',
  '2_discipline': 'assets/icons/badges/2_discipline.svg',
  '3_discipline': 'assets/icons/badges/3_discipline.svg',
  '4_discipline': 'assets/icons/badges/4_discipline.svg',
  '5_discipline': 'assets/icons/badges/5_discipline.svg',
};

final badgeTitles = {
  '1_focus': "Tập trung I",
  '2_focus': "Tập trung II",
  '3_focus': "Tập trung II",
  '4_focus': "Tập trung IV",
  '5_focus': "Tập trung V",
  '1_hardwork': "Chăm chỉ I",
  '2_hardwork': "Chăm chỉ II",
  '3_hardwork': "Chăm chỉ II",
  '4_hardwork': "Chăm chỉ IV",
  '5_hardwork': "Chăm chỉ V",
  '1_persevere': "Kiên trì I",
  '2_persevere': "Kiên trì II",
  '3_persevere': "Kiên trì II",
  '4_persevere': "Kiên trì IV",
  '5_persevere': "Kiên trì V",
  '1_discipline': "Kỉ luật I",
  '2_discipline': "Kỉ luật II",
  '3_discipline': "Kỉ luật II",
  '4_discipline': "Kỉ luật IV",
  '5_discipline': "Kỉ luật V",
};

final badgeDescriptions = {
  '1_focus': "Bạn đã học với ${Constants.appName} tổng 2 giờ trong một ngày!",
  '2_focus': "Bạn đã học với ${Constants.appName} tổng 4 giờ trong một ngày!",
  '3_focus': "Bạn đã học với ${Constants.appName} tổng 6 giờ trong một ngày!",
  '4_focus': "Bạn đã học với ${Constants.appName} tổng 8 giờ trong một ngày!",
  '5_focus': "Bạn đã học với ${Constants.appName} tổng 10 giờ trong một ngày!",
  '1_hardwork': "Bạn đã học với ${Constants.appName} 10 giờ!",
  '2_hardwork': "Bạn đã học với ${Constants.appName} 100 giờ!",
  '3_hardwork': "Bạn đã học với ${Constants.appName} 1000 giờ!",
  '4_hardwork': "Bạn đã học với ${Constants.appName} 5000 giờ!",
  '5_hardwork': "Bạn đã học với ${Constants.appName} 10000 giờ!",
  '1_persevere': "Bạn đã tham gia ${Constants.appName} 7 ngày!",
  '2_persevere': "Bạn đã tham gia ${Constants.appName} 30 ngày!",
  '3_persevere': "Bạn đã tham gia ${Constants.appName} 90 ngày!",
  '4_persevere': "Bạn đã tham gia ${Constants.appName} 180 ngày!",
  '5_persevere': "Bạn đã tham gia ${Constants.appName} 365 ngày!",
  '1_discipline':
      "Bạn đã duy trì chuỗi học tập của mình trong 3 ngày liên tiếp!",
  '2_discipline':
      "Bạn đã duy trì chuỗi học tập của mình trong 7 ngày liên tiếp!",
  '3_discipline':
      "Bạn đã duy trì chuỗi học tập của mình trong 21 ngày liên tiếp!",
  '4_discipline':
      "Bạn đã duy trì chuỗi học tập của mình trong 50 ngày liên tiếp!",
  '5_discipline':
      "Bạn đã duy trì chuỗi học tập của mình trong 100 ngày liên tiếp!",
};

/// Acquired when user studied in rooms for a total of {x} hours
final hardworkBadgeRequirements = [10, 100, 1000, 5000, 10000];

/// Acquired when user studied {x} amount of hours in one day.
final focusBadgeRequirements = [2, 4, 6, 8, 10];

/// Acquired when user continue streaks for {x} amount of days in a row.
final disciplineBadgeRequirements = [3, 7, 21, 50, 100];

/// Acquired when user use the app for a total of {x} days.
final persevereBadgeRequirements = [7, 30, 90, 180, 365];
