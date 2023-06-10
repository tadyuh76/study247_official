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
  const NumberInput({
    super.key,
    required this.controller,
    required this.hintText,
    required this.title,
    required this.onEditingComplete,
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
    if (int.parse(curVal) >= 50) return;
    widget.controller.text = (int.parse(curVal) + 1).toString();
  }

  void decreaseValue() {
    String curVal = widget.controller.text;
    if (int.parse(curVal) <= 0) return;
    widget.controller.text = (int.parse(curVal) - 1).toString();
  }

  void validate(String value) {
    if (value.isEmpty) return;
    if (int.parse(value) >= 50) {
      widget.controller.text = '50';
    }
  }

  void _onEditingComplete() {
    if (widget.controller.text.isEmpty) {
      widget.controller.text = '0';
    }
    widget.onEditingComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Constants.defaultPadding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputTitle(title: widget.title),
          const SizedBox(height: Constants.defaultPadding / 2),
          Row(
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
      ),
    );
  }
}
