import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/shared/widgets/app_error.dart';
import 'package:study247/core/shared/widgets/app_loading.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';
import 'package:study247/features/notification/controller/notification_controller.dart';
import 'package:study247/features/notification/widget/notification_widget.dart';

class NotificationDialog extends ConsumerWidget {
  const NotificationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FeatureDialog(
      title: "Thông báo",
      iconPath: IconPaths.notification,
      child: ref.watch(notificationControllerProvider).when(
            error: (err, stk) => const AppError(),
            loading: () => const AppLoading(),
            data: (notificationList) {
              if (notificationList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text("Bạn chưa có thông báo nào!")),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: notificationList.length,
                itemBuilder: (context, index) {
                  return NotificationWidget(
                    notification: notificationList[index],
                  );
                },
              );
            },
          ),
    );
  }
}
