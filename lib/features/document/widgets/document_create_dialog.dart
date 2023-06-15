import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class DocumentCreateDialog extends StatelessWidget {
  const DocumentCreateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: Container(
          decoration: const BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(Constants.defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Tạo mới",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: Constants.defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _renderCreateButton(
                    iconName: Icons.folder,
                    title: "Thư mục",
                    onTap: () {},
                  ),
                  const SizedBox(width: Constants.defaultPadding / 2),
                  _renderCreateButton(
                    iconName: Icons.edit_document,
                    title: "Tài liệu",
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: Constants.defaultPadding / 2),
            ],
          ),
        ),
      ),
    );
  }

  Column _renderCreateButton({
    required IconData iconName,
    required String title,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Palette.lightGrey,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              width: 100,
              height: 100,
              child: Center(
                child: Icon(
                  iconName,
                  size: 64,
                  color: Palette.darkGrey,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: Constants.defaultPadding / 2),
        Text(title),
      ],
    );
  }
}
