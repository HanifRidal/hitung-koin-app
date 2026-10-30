import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/values/app_strings.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.account_balance_wallet_rounded,
                size: 48,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.appTagline,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

