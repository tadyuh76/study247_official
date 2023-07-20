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
        horizontal: Constants.defaultPadding,
      ).copyWith(bottom: Constants.defaultPadding),
      padding: const EdgeInsets.all(Constants.defaultPadding),
      decoration: const BoxDecoration(
          color: Palette.primary,
          borderRadius: BorderRadius.all(
            Radius.circular(Constants.defaultBorderRadius),
          ),
          image: DecorationImage(
            image: AssetImage("assets/images/card_background.png"),
            fit: BoxFit.cover,
          )
          // boxShadow: [BoxShadow(blurRadius: 4, color: Palette.shadow)],
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Học cùng nhau\nmọi lúc, mọi nơi\nvới Study247!",
            style: TextStyle(
              fontSize: 18,
              height: 1.4,
              fontWeight: FontWeight.w500,
              color: Palette.white,
            ),
          ),
          const SizedBox(height: 30),
          CustomButton(
            text: "Tạo phòng học mới",
            onTap: () => _showCreateDialog(context),
          ),
        ],
      ),
    );
  }
}
