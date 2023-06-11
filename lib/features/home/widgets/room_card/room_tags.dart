import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class RoomTags extends StatelessWidget {
  final List<dynamic> tags;
  const RoomTags({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tags
            .map(
              (tag) => Container(
                margin:
                    const EdgeInsets.only(right: Constants.defaultPadding / 2),
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: Constants.defaultPadding / 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Palette.lightGrey,
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Palette.darkGrey,
                    fontSize: 12,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
