import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../routes/app_routes.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavBar({super.key, required this.currentIndex});

  static const _routes = [Routes.home, Routes.transaction, Routes.report];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Transaksi'),
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart_rounded), label: 'Laporan'),
      ],
      onTap: (index) {
        if (index != currentIndex && index < _routes.length) {
          Get.offAllNamed(_routes[index]);
        }
      },
    );
  }
}
