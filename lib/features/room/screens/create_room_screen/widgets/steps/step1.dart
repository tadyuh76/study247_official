import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/features/room/controllers/room_info_controller.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/number_input.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/text_input.dart';
import 'package:study247/utils/unfocus.dart';

class Step1 extends ConsumerStatefulWidget {
  const Step1({super.key});

  @override
  ConsumerState<Step1> createState() => _Step1State();
}

class _Step1State extends ConsumerState<Step1> {
  final _nameController = TextEditingController();
  final _participantsController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _participantsController.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Unfocus(
      child: Column(
        children: [
          AppTextInput(
            title: "Tên phòng học",
            hintText: "Học cùng mình!",
            controller: _nameController,
            onEditingComplete: () => ref
                .read(roomInfoControllerProvider)
                .updateRoomInfo(name: _nameController.text.trim()),
          ),
          const SizedBox(height: Constants.defaultPadding * 2),
          NumberInput(
            controller: _participantsController,
            hintText: "5",
            title: "Số lượng thành viên tối đa",
            maxValue: 10,
            minValue: 1,
            interval: 1,
            onEditingComplete: () => ref
                .read(roomInfoControllerProvider)
                .updateRoomInfo(
                    maxParticipants: int.parse(_participantsController.text)),
          ),
          const SizedBox(height: Constants.defaultPadding * 2),
          AppTextInput(
            title: "Mô tả",
            hintText: "Tham gia phòng của mình để cùng nhau học nhé!",
            controller: _descriptionController,
            onEditingComplete: () => ref
                .read(roomInfoControllerProvider)
                .updateRoomInfo(
                    description: _descriptionController.text.trim()),
          ),
        ],
      ),
    );
  }
}
