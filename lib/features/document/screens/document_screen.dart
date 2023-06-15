import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/core/shared/widgets/custom_icon_button.dart';
import 'package:study247/features/document/screens/document_tab.dart';
import 'package:study247/features/document/screens/folder_tab.dart';
import 'package:study247/features/document/widgets/document_create_dialog.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  const DocumentScreen({super.key});

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  int _currentTabIdx = 0;
  bool get _isDocumentTab => _currentTabIdx == 0;
  final _pageController = PageController();

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
      floatingActionButton: CustomIconButton(
        onTap: () => _showCreateDialog(context),
        backgroundColor: Palette.primary,
        size: 60,
        child: const Icon(
          Icons.add,
          color: Palette.white,
        ),
      ),
      appBar: _renderAppBar(context),
      body: PageView(
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentTabIdx = index),
        physics: const NeverScrollableScrollPhysics(),
        children: const [DocumentTab(), FolderTab()],
      ),
    );
  }

  AppBar _renderAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Palette.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => _changeTab(0),
            child: Text(
              "Tài liệu",
              style: TextStyle(
                color: _isDocumentTab ? Palette.primary : Palette.darkGrey,
                fontWeight:
                    _isDocumentTab ? FontWeight.w500 : FontWeight.normal,
                fontSize: 20,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _changeTab(1),
            child: Text(
              "Thư mục",
              style: TextStyle(
                color: !_isDocumentTab ? Palette.primary : Palette.darkGrey,
                fontWeight:
                    !_isDocumentTab ? FontWeight.w500 : FontWeight.normal,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
