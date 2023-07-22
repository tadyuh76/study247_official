import 'package:flutter/material.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/input_title.dart';

class AppTextInput extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController controller;
  final VoidCallback onEditingComplete;

  const AppTextInput({
    Key? key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputTitle(title: title),
        TextFormField(
          onTapOutside: (_) => onEditingComplete(),
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Palette.grey,
              fontSize: 14,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Palette.darkGrey,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Palette.primary,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
