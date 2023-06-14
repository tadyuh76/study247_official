import 'package:flutter/material.dart';
import 'package:study247/core/palette.dart';
import 'package:study247/features/document/screens/document_screen.dart';
import 'package:study247/features/history/screens/history_screen.dart';
import 'package:study247/features/home/home_screen.dart';

class BottomNavigatorWrapper extends StatefulWidget {
  const BottomNavigatorWrapper({super.key});

  @override
  State<BottomNavigatorWrapper> createState() => _BottomNavigatorWrapperState();
}

class _BottomNavigatorWrapperState extends State<BottomNavigatorWrapper> {
  int _currentIndex = 0;

  final screens = const [HomeScreen(), DocumentScreen(), HistoryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Palette.white,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Phòng học',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Tài liệu',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Lịch sử',
          ),
        ],
      ),
    );
  }
}
