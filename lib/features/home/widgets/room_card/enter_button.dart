import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/core/models/room.dart';
import 'package:study247/core/palette.dart';

class EnterButton extends ConsumerStatefulWidget {
  final RoomModel room;
  const EnterButton({super.key, required this.room});

  @override
  ConsumerState<EnterButton> createState() => _EnterButtonState();
}

class _EnterButtonState extends ConsumerState<EnterButton> {
  bool joining = false;

  void onTap([mounted = true]) async {
    // setState(() => joining = true);

    final roomId = widget.room.id!;
    context.go("/room/$roomId/${widget.room.meetingId}");
    // showSnackBar(context, "Đã tham gia phòng học!");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Material(
        color: Palette.primary,
        borderRadius: BorderRadius.circular(10),
        child: IgnorePointer(
          ignoring: joining,
          child: InkWell(
            onTap: onTap,
            child: const Center(
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
    );
  }
}
