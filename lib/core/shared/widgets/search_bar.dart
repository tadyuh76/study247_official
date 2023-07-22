import 'package:flutter/material.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({super.key, required this.hintText});
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Constants.defaultPadding),
      child: TextField(
        style: const TextStyle(fontSize: 14, color: Palette.black),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 32),
          hintText: hintText,
          hintStyle: const TextStyle(color: Palette.darkGrey, fontSize: 16),
        ),
      ),
    );
  }
}
