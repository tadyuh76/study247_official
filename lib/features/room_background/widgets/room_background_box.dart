import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/constants/icons.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/color_picker.dart';
import 'package:study247/core/shared/widgets/feature_dialog.dart';
import 'package:study247/features/room_background/controllers/room_background_controller.dart';
import 'package:study247/utils/unfocus.dart';
import 'package:study247/utils/youtube.dart';

class RoomBackgroundBox extends ConsumerStatefulWidget {
  const RoomBackgroundBox({super.key});

  @override
  ConsumerState<RoomBackgroundBox> createState() => _RoomBackgroundBoxState();
}

class _RoomBackgroundBoxState extends ConsumerState<RoomBackgroundBox> {
  bool allowSound = true;
  int _selectingColorIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  void _onColorSelect(int colorIdx) {
    _selectingColorIndex = colorIdx;
    ref
        .read(roomBackgroundControllerProvider)
        .selectColorBackground(bannerColors.keys.elementAt(colorIdx));
    setState(() {});
  }

  void _onSubmitUrl() {
    ref.read(roomBackgroundControllerProvider).loadVideoByURL();
  }

  void _onSelectRecommendedVideo(int index) {
    ref.read(roomBackgroundControllerProvider).updateSelectingVideoIdx(index);
    ref.read(roomBackgroundControllerProvider).loadVideoOnSelect();
  }

  @override
  Widget build(BuildContext context) {
    return FeatureDialog(
      title: "Nền",
      iconPath: IconPaths.image,
      child: Unfocus(
        child: ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: Constants.defaultPadding),
                const Text(
                  "Màu sắc",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                ColorPicker(
                  selectingColorIdx: _selectingColorIndex,
                  onSelect: _onColorSelect,
                ),
                if (!kIsWeb) ..._renderMobileOptions()
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _renderMobileOptions() {
    final provider = ref.watch(roomBackgroundControllerProvider);
    final urlController = provider.urlController;
    final selectingVideoIdx = provider.selectingVideoIdx;

    final size = MediaQuery.of(context).size;

    return [
      const SizedBox(height: Constants.defaultPadding),
      const Text(
        "Youtube Video",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: Constants.defaultPadding / 2),
      _renderYoutubeURLInput(urlController),
      const SizedBox(height: Constants.defaultPadding / 2),
      const Text(
        "Gợi ý",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: Constants.defaultPadding / 2),
      _renderRecommendedVideos(size, selectingVideoIdx),
      const SizedBox(height: Constants.defaultPadding),
      Row(
        children: [
          const Text(
            "Âm thanh",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Switch(
            value: allowSound,
            onChanged: (value) {
              setState(() => allowSound = value);
              if (value == true) {
                provider.videoController.unMute();
              } else {
                provider.videoController.mute();
              }
            },
          ),
        ],
      ),
    ];
  }

  SizedBox _renderRecommendedVideos(Size size, int selectingVideoIdx) {
    return SizedBox(
      height: size.width - 4 * Constants.defaultPadding,
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final isSelecting = selectingVideoIdx == index;
            return GestureDetector(
              onTap: () => _onSelectRecommendedVideo(index),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Palette.lightGrey,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                    color: isSelecting ? Palette.black : Palette.lightGrey,
                    width: 3,
                  ),
                  image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: NetworkImage(
                      getYoutubeThumbnailUrl(recommendYoutubeIds[index]),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Row _renderYoutubeURLInput(TextEditingController urlController) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            style: const TextStyle(fontSize: 14),
            controller: urlController,
            decoration: const InputDecoration(
              hintText: "Youtube video URL",
              hintStyle: TextStyle(color: Palette.darkGrey),
              isDense: true,
              contentPadding: EdgeInsets.all(15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Palette.darkGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Palette.darkGrey),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          decoration: const BoxDecoration(
            color: Palette.primary,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: IconButton(
            onPressed: _onSubmitUrl,
            icon: const Icon(Icons.check, color: Palette.white),
          ),
        ),
      ],
    );
  }
}
