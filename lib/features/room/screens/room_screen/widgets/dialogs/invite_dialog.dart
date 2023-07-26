import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';
import 'package:study247/features/room/controllers/room_controller.dart';
import 'package:study247/utils/show_snack_bar.dart';
import 'package:study247/utils/unfocus.dart';

class InviteDialog extends ConsumerStatefulWidget {
  const InviteDialog({super.key});

  @override
  ConsumerState<InviteDialog> createState() => _InviteDialogState();
}

class _InviteDialogState extends ConsumerState<InviteDialog> {
  final _urlController = TextEditingController();
  bool copied = false;

  @override
  void initState() {
    super.initState();
    final room = ref.read(roomControllerProvider).asData!.value!;

    _urlController.text =
        "study247.vercel.app/#/room/${room.id}?meetingId=${room.meetingId}";
  }

  void _copyUrl(BuildContext context) {
    Clipboard.setData(ClipboardData(text: _urlController.text)).whenComplete(
      () {
        showSnackBar(context, "Đã sao chép đường dẫn");
        setState(() {
          copied = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDialog(
      title: "Mời bạn",
      iconPath: IconPaths.addPeople,
      child: Unfocus(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: kIsWeb ? 30 : 20),
            const Text("Việc học sẽ thú vị hơn nhiều khi có bạn bè đó!"),
            const SizedBox(height: Constants.defaultPadding),
            TextField(
              onChanged: (value) {},
              controller: _urlController,
              onTap: () => _copyUrl(context),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
            ),
            const SizedBox(height: Constants.defaultPadding),
            if (copied)
              const Text(
                "Đã sao chép đường dẫn!",
                style: TextStyle(color: Palette.primary),
              )
          ],
        ),
      ),
    );
  }
}
