import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import 'package:study247/constants/common.dart';
import "package:study247/core/palette.dart";
import "package:study247/core/shared/widgets/custom_button.dart";
import 'package:study247/utils/show_snack_bar.dart';
import "package:study247/features/room/controllers/create_room_controller.dart";
import "package:study247/features/room/controllers/room_controller.dart";
import "package:study247/features/room/screens/create_room_screen/widgets/steps/step1.dart";
import "package:study247/features/room/screens/create_room_screen/widgets/steps/step2.dart";
import "package:study247/features/room/screens/create_room_screen/widgets/steps/step3.dart";

final steps = [
  (1, "Cơ bản", const Step1()),
  (2, "Chức năng", const Step2()),
  (3, "Trang trí", const Step3()),
];

class CreateRoomScreen extends ConsumerStatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  ConsumerState<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends ConsumerState<CreateRoomScreen> {
  int _currentStep = 0;

  void _onStepContinue() {
    final room = ref.read(roomInfoControllerProvider).room;

    if (_currentStep == 0 && room.name.isEmpty) {
      showSnackBar(context, "Tên phòng học không được bỏ trống!");
      return;
    }

    if (_currentStep < steps.length) setState(() => _currentStep++);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void _onStepCancel() {
    if (_currentStep > 0) setState(() => _currentStep--);
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<void> _onSubmit() async {
    await ref.read(roomControllerProvider.notifier).createRoom(context);

    if (mounted) {
      context.pop();
      context.go(
        "/room/${ref.read(roomControllerProvider).asData!.value!.id.toString()}",
      );
    }
    ref.read(roomInfoControllerProvider).reset();
  }

  Widget _controlsBuilder(context, details) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Constants.defaultPadding),
      child: Row(
        children: [
          if (_currentStep > 0)
            CustomButton(text: 'Trở lại', onTap: _onStepCancel),
          const Spacer(),
          if (_currentStep < steps.length - 1)
            CustomButton(text: 'Tiếp', onTap: _onStepContinue)
          else
            CustomButton(text: 'Hoàn tất', onTap: _onSubmit),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tạo phòng học nhóm"),
        backgroundColor: Palette.white,
      ),
      backgroundColor: Palette.white,
      body: Stepper(
        currentStep: _currentStep,
        type: StepperType.horizontal,
        elevation: 0,
        controlsBuilder: _controlsBuilder,
        steps: steps
            .map(
              (step) => Step(
                isActive: _currentStep >= step.$1,
                title: Text(step.$2),
                content: step.$3,
              ),
            )
            .toList(),
      ),
    );
  }
}
