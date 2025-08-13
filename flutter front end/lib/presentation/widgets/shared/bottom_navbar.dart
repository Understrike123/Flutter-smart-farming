import 'dart:ui';

import 'package:flutter/material.dart';

class BotNavBarCustom extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const BotNavBarCustom({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.transparent,
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.transparent,
        //     // offset: Offset(0, 4),
        //     // blurRadius: 12,
        //     // spreadRadius: 3,
        //   ),
        // ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),

        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent, // Lebih transparan
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.0,
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onTabTapped,
            type: BottomNavigationBarType.fixed,
            // backgroundColor: Colors.white.withOpacity(0.6),
            selectedFontSize: 12,
            unselectedFontSize: 11,
            iconSize: 26,
            elevation: 0,
            items: [
              _buildNavItem(Icons.home, 'Beranda', 0),
              _buildNavItem(Icons.sensors, 'Sensor', 1),
              _buildNavItem(Icons.touch_app, 'Kontrol', 2),
              _buildNavItem(Icons.analytics, 'Analisis', 3),
            ],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    IconData icon,
    String label,
    int index,
  ) {
    final bool isSelected = currentIndex == index;

    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF4CAF50) : const Color(0xFF9E9E9E),
        ),
      ),
      label: label,
    );
  }
}
