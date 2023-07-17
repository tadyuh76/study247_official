import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/features/home/widgets/create_dialog.dart';

class CreateCard extends StatelessWidget {
  const CreateCard({super.key});

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const RoomCreateDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: Constants.defaultPadding,
      ),
      padding: const EdgeInsets.all(Constants.defaultPadding),
      decoration: const BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [BoxShadow(blurRadius: 4, color: Palette.shadow)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "HỌC CÙNG NHAU",
            style: TextStyle(
              fontSize: 20,
              letterSpacing: -0.5,
              fontWeight: FontWeight.w500,
              color: Palette.black,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Kết nối những tâm hồn yêu học tập!",
            style: TextStyle(color: Palette.darkGrey),
          ),
          const SizedBox(height: Constants.defaultPadding * 2),
          CustomButton(
            text: "Tạo phòng học",
            primary: true,
            onTap: () => _showCreateDialog(context),
          ),
        ],
      ),
    );
  }
}
