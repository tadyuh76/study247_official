import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/models/room.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/home/widgets/room_card/avatar.dart';
import 'package:study247/features/home/widgets/room_card/enter_button.dart';
import 'package:study247/features/home/widgets/room_card/num_participants.dart';
import 'package:study247/features/home/widgets/room_card/room_tags.dart';

class RoomCard extends StatelessWidget {
  final RoomModel room;
  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Constants.defaultPadding)
          .copyWith(bottom: Constants.defaultPadding),
      decoration: BoxDecoration(
        color: Palette.white,
        borderRadius: BorderRadius.circular(16),
        // boxShadow: const [BoxShadow(blurRadius: 16, color: Palette.shadow)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              renderCardCover(),
              Positioned(
                bottom: -20,
                left: 20,
                child: Avatar(radius: 20, photoURL: room.hostPhotoUrl),
              ),
              NumParticipants(
                curParticipants: room.curParticipants,
                maxParticipants: room.maxParticipants,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: Constants.defaultPadding / 2),
                RoomTags(tags: room.tags),
                const SizedBox(height: Constants.defaultPadding / 2),
                Text(
                  room.description,
                  maxLines: 3,
                  style: const TextStyle(
                    color: Palette.darkGrey,
                    fontSize: 14,
                    // fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: Constants.defaultPadding / 2),
                EnterButton(room: room),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget renderCardCover() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80,
          width: double.infinity,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(Constants.defaultPadding),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: bannerColors[room.bannerColor],
          ),
          child: Text(
            room.name,
            maxLines: 2,
            style: const TextStyle(
              color: Palette.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
