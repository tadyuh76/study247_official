import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class ColorPicker extends StatelessWidget {
  final int selectingColorIdx;
  final void Function(int) onSelect;
  const ColorPicker({
    Key? key,
    required this.selectingColorIdx,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: Constants.defaultPadding / 2,
        mainAxisSpacing: Constants.defaultPadding / 2,
        childAspectRatio: 1,
      ),
      itemCount: 10,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () => onSelect(index),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bannerColors.values.toList()[index],
                ),
              ),
            ),
            if (selectingColorIdx == index)
              const Align(
                alignment: Alignment.bottomRight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Palette.black,
                  ),
                  child: Icon(
                    Icons.check,
                    size: 12,
                    color: Palette.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
