import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_strings.dart';
import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navReports),
      ),
      body: const Center(
        child: Text('Laporan & Statistik'),
      ),
    );
  }
}

