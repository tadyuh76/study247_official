import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/room.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/utils/show_snack_bar.dart';

class EnterButton extends ConsumerStatefulWidget {
  final RoomModel room;
  const EnterButton({super.key, required this.room});

  @override
  ConsumerState<EnterButton> createState() => _EnterButtonState();
}

class _EnterButtonState extends ConsumerState<EnterButton> {
  bool joining = false;

  void onTap([mounted = true]) async {
    if (widget.room.curParticipants >= widget.room.maxParticipants) {
      showSnackBar(context, "Phòng học đã đầy!");
      return;
    }

    final roomId = widget.room.id!;
    context.go("/room/$roomId?meetingId=${widget.room.meetingId}");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: Palette.primary,
        borderRadius: BorderRadius.circular(10),
        child: IgnorePointer(
          ignoring: joining,
          child: InkWell(
            onTap: onTap,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Constants.defaultPadding,
                vertical: 15,
              ),
              child: Center(
                child: Text(
                  'Vào phòng học',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
