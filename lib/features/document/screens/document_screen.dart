import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/constants/common.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/document/screens/document_tab.dart';
import 'package:study247/features/document/screens/folder_tab.dart';
import 'package:study247/features/document/widgets/document_create_dialog.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final bool navigateFromRoom;
  const DocumentScreen({
    super.key,
    this.navigateFromRoom = false,
  });

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  final _pageController = PageController();
  int _currentTabIdx = 0;

  void _showCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const DocumentCreateDialog(),
      barrierDismissible: true,
    );
  }

  void _changeTab(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.lightGrey,
      appBar: widget.navigateFromRoom ? _renderAppBar() : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        backgroundColor: Palette.white,
        child: const Icon(
          Icons.add_rounded,
          color: Palette.primary,
          size: 32,
        ),
      ),
      body: Column(
        children: [
          _renderHeader(),
          Expanded(
            child: PageView(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentTabIdx = index),
              physics: const NeverScrollableScrollPhysics(),
              children: const [DocumentTab(), FolderTab()],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _renderAppBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: true,
      backgroundColor: Palette.lightGrey,
    );
  }

  Widget _renderHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.defaultPadding,
        vertical: Constants.defaultPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => _changeTab(0),
                child: Text(
                  "Tài liệu",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: _currentTabIdx == 0 ? FontWeight.w500 : null,
                    color:
                        _currentTabIdx == 0 ? Palette.black : Palette.darkGrey,
                  ),
                ),
              ),
              const Text(
                "  •  ",
                style: TextStyle(fontSize: 24, color: Palette.darkGrey),
              ),
              GestureDetector(
                onTap: () => _changeTab(1),
                child: Text(
                  "Thư mục",
                  style: TextStyle(
                    color:
                        _currentTabIdx == 1 ? Palette.black : Palette.darkGrey,
                    fontWeight: _currentTabIdx == 1 ? FontWeight.w500 : null,
                    fontSize: 24,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            "Quản lý tài liệu thông minh",
            style: TextStyle(color: Palette.darkGrey),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
