import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class PushNotificationService {
  static final _notificationService = PushNotificationService._internal();
  factory PushNotificationService() => _notificationService;
  PushNotificationService._internal();

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    const androidSettings =
        AndroidInitializationSettings("@mipmap/launcher_icon");

    const settings = InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(settings);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required Duration duration,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(duration),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'main_channel',
          'Main Channel',
          channelDescription: "tadyuh_notifications",
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
