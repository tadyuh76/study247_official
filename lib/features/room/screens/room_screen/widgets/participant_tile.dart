import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/models/user.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/mastery_avatar.dart';
import 'package:study247/features/room/screens/room_screen/widgets/dialogs/participant_info_dialog.dart';
import 'package:videosdk/videosdk.dart';

class ParticipantTile extends StatefulWidget {
  final Participant participant;
  final UserModel user;
  const ParticipantTile(
      {super.key, required this.participant, required this.user});

  @override
  State<ParticipantTile> createState() => _ParticipantTileState();
}

class _ParticipantTileState extends State<ParticipantTile> {
  Stream? videoStream;

  @override
  void initState() {
    widget.participant.streams.forEach((key, Stream stream) {
      setState(() {
        if (stream.kind == 'video') {
          videoStream = stream;
        }
      });
    });
    _initStreamListeners();
    super.initState();
  }

  void _initStreamListeners() {
    widget.participant.on(Events.streamEnabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => videoStream = stream);
      }
    });

    widget.participant.on(Events.streamDisabled, (Stream stream) {
      if (stream.kind == 'video') {
        setState(() => videoStream = null);
      }
    });
  }

  void _showParticipantInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => ParticipantInfoDialog(user: widget.user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: videoStream != null
              ? RTCVideoView(
                  videoStream?.renderer as RTCVideoRenderer,
                  mirror: true,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                )
              : Container(
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: MasteryAvatar(
                      radius: 40,
                      photoURL: widget.user.photoURL,
                      masteryLevel: widget.user.masteryLevel,
                    ),
                  ),
                ),
        ),
        _renderParticipantInfo(),
      ],
    );
  }

  Widget _renderParticipantInfo() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: GestureDetector(
        onTap: _showParticipantInfoDialog,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Palette.black.withOpacity(0.7),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                masteryIconPaths[widget.user.masteryLevel],
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 5),
              Text(
                widget.user.displayName,
                style: const TextStyle(fontSize: 12, color: Palette.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
