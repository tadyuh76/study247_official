import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:study247/core/shared/widgets/custom_button.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class CreateCard extends StatelessWidget {
  const CreateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Container(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        decoration: const BoxDecoration(
            color: Palette.primary,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Học cùng nhau",
              style: TextStyle(
                fontSize: 24,
                color: Palette.white,
              ),
            ),
            const SizedBox(height: Constants.defaultPadding / 2),
            const Text(
              "Kết nối những tâm hồn yêu học tập!",
              style: TextStyle(color: Palette.white),
            ),
            const SizedBox(height: Constants.defaultPadding),
            CustomButton(
              text: "Tạo phòng học",
              onTap: () => GoRouter.of(context).go("/create"),
            ),
          ],
        ),
      ),
    );
  }
}
