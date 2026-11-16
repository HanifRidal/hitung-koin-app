import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../widgets/app_bottom_nav_bar.dart';
import '../controllers/report_controller.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Laporan'), centerTitle: false),
      body: Obx(() {
        final income = controller.totalIncome;
        final expense = controller.totalExpense;
        final hasData = (income + expense) > 0;

        if (!hasData) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pie_chart_outline, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text('Belum ada transaksi untuk grafik', style: TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }

        // ponytail: two-slice breakdown only; upgrade to per-category aggregation when categories seeded
        final sections = [
          if (income > 0)
            PieChartSectionData(
              value: income,
              color: AppColors.income,
              title: '${(income / (income + expense) * 100).toStringAsFixed(0)}%',
              titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              radius: 50,
            ),
          if (expense > 0)
            PieChartSectionData(
              value: expense,
              color: AppColors.expense,
              title: '${(expense / (income + expense) * 100).toStringAsFixed(0)}%',
              titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              radius: 50,
            ),
        ];

        return RefreshIndicator(
          onRefresh: () => controller.loadData(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(sections: sections, centerSpaceRadius: 40, sectionsSpace: 2),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.arrow_downward, color: AppColors.income),
                  title: const Text('Total Pemasukan'),
                  trailing: Text(
                    currency.format(income),
                    style: const TextStyle(color: AppColors.income, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.arrow_upward, color: AppColors.expense),
                  title: const Text('Total Pengeluaran'),
                  trailing: Text(
                    currency.format(expense),
                    style: const TextStyle(color: AppColors.expense, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.account_balance_wallet, color: AppColors.accent),
                  title: const Text('Selisih Bersih'),
                  trailing: Text(
                    currency.format(income - expense),
                    style: TextStyle(
                      color: (income - expense) >= 0 ? AppColors.income : AppColors.expense,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }
}
