import 'package:flutter/material.dart';
import 'package:study247/core/models/notification.dart';
import 'package:study247/core/palette.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationModel notification;
  const NotificationWidget({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Palette.lightGrey,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(notification.text),
    );
  }
}
