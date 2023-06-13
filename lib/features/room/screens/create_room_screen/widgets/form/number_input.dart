import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/room/screens/create_room_screen/widgets/form/input_title.dart';

class NumberInput extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final String hintText;
  final VoidCallback onEditingComplete;
  final int maxValue;
  final int minValue;
  final int interval;
  final bool centered;

  const NumberInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
    required this.onEditingComplete,
    required this.maxValue,
    required this.minValue,
    required this.interval,
    this.centered = false,
  });

  @override
  State<NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<NumberInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.hintText;
  }

  void increaseValue() {
    String curVal = widget.controller.text;
    if (int.parse(curVal) >= widget.maxValue) return;
    widget.controller.text = (int.parse(curVal) + widget.interval).toString();
  }

  void decreaseValue() {
    String curVal = widget.controller.text;
    if (int.parse(curVal) <= widget.minValue) return;
    widget.controller.text = (int.parse(curVal) - widget.interval).toString();
  }

  void validate(String value) {
    if (value.isEmpty) return;
    if (int.parse(value) >= widget.maxValue) {
      widget.controller.text = widget.maxValue.toString();
    }
    if (int.parse(value) <= widget.minValue) {
      widget.controller.text = widget.minValue.toString();
    }
  }

  void _onEditingComplete() {
    if (widget.controller.text.isEmpty) {
      widget.controller.text = widget.minValue.toString();
    }
    widget.onEditingComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: widget.centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        InputTitle(title: widget.title, centered: widget.centered),
        const SizedBox(height: Constants.defaultPadding / 2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: Material(
                color: Palette.lightGrey,
                clipBehavior: Clip.hardEdge,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: InkWell(
                  onTap: decreaseValue,
                  child: const Icon(Icons.remove),
                ),
              ),
            ),
            const SizedBox(width: Constants.defaultPadding / 2),
            SizedBox(
              width: 80,
              height: 40,
              child: TextFormField(
                onTapOutside: (_) => _onEditingComplete(),
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: widget.controller,
                onChanged: validate,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: const TextStyle(
                    color: Palette.lightGrey,
                    fontSize: 12,
                    height: 1,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Palette.primary,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Palette.darkGrey,
                      width: 4,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: Constants.defaultPadding / 2),
            SizedBox(
              height: 40,
              width: 40,
              child: Material(
                color: Palette.lightGrey,
                clipBehavior: Clip.hardEdge,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: InkWell(
                  onTap: increaseValue,
                  child: const Icon(Icons.add),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
