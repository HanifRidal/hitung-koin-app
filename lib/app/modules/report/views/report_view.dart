import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../routes/app_routes.dart";
import "../controllers/report_controller.dart";
import "../../../data/models/transaction_model.dart";

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan'),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.pie_chart, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Belum ada data transaksi'),
              ],
            ),
          );
        }

        // Simple list view of transactions as placeholder for charts
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.transactions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final txn = controller.transactions[index];
            final isIncome = txn.type == TransactionType.income;
            return Card(
              child: ListTile(
                leading: Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isIncome ? AppColors.income : AppColors.expense,
                ),
                title: Text(txn.note ?? (isIncome ? 'Pemasukan' : 'Pengeluaran')),
                trailing: Text(
                  '${isIncome ? '+' : '-'} ${currencyFormatter.format(txn.amount)}',
                  style: TextStyle(
                    color: isIncome ? AppColors.income : AppColors.expense,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_rounded),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_rounded),
            label: 'Laporan',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Get.offAllNamed(Routes.home);
          } else if (index == 1) {
            Get.offAllNamed(Routes.transaction);
          }
        },
      ),
    );
  }
}
