import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/models/transaction_model.dart';
import '../../../widgets/app_bottom_nav_bar.dart';
import '../controllers/transaction_controller.dart';

class TransactionView extends GetView<TransactionController> {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final dateFormatter = DateFormat('dd MMM yyyy, HH:mm');

    return Scaffold(
      appBar: AppBar(title: const Text('Transaksi'), centerTitle: false),
      body: Obx(() {
        if (controller.transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada transaksi',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadAll(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.transactions.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final txn = controller.transactions[index];
              final isIncome = txn.type == TransactionType.income;
              final categoryName = controller.getCategoryName(txn.categoryId);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        isIncome ? AppColors.primaryLight : Colors.red.shade100,
                    child: Icon(
                      isIncome
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded,
                      color: isIncome ? AppColors.income : AppColors.expense,
                    ),
                  ),
                  title: Text(
                    txn.note?.isNotEmpty == true ? txn.note! : categoryName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('$categoryName • ${dateFormatter.format(txn.date)}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${isIncome ? '+' : '-'} ${currencyFormatter.format(txn.amount)}',
                        style: TextStyle(
                          color: isIncome ? AppColors.income : AppColors.expense,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () => controller.deleteTransaction(txn),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddTransactionDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    if (controller.accounts.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Tambahkan dompet/akun terlebih dahulu di Beranda.',
      );
      return;
    }

    final amountController = TextEditingController();
    final noteController = TextEditingController();
    final selectedType = TransactionType.expense.obs;
    final selectedAccountId = (controller.accounts.first.id ?? 1).obs;

    final initialCats = controller.categoriesForType(selectedType.value);
    final selectedCategoryId = (initialCats.isNotEmpty ? initialCats.first.id ?? 1 : 1).obs;

    Get.defaultDialog(
      title: 'Tambah Transaksi',
      content: Obx(
        () {
          final filteredCategories = controller.categoriesForType(selectedType.value);
          if (!filteredCategories.any((c) => c.id == selectedCategoryId.value) &&
              filteredCategories.isNotEmpty) {
            selectedCategoryId.value = filteredCategories.first.id ?? 1;
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Pengeluaran')),
                      selected: selectedType.value == TransactionType.expense,
                      selectedColor: Colors.red.shade100,
                      onSelected: (val) {
                        if (val) selectedType.value = TransactionType.expense;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ChoiceChip(
                      label: const Center(child: Text('Pemasukan')),
                      selected: selectedType.value == TransactionType.income,
                      selectedColor: AppColors.primaryLight,
                      onSelected: (val) {
                        if (val) selectedType.value = TransactionType.income;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: selectedAccountId.value,
                decoration: const InputDecoration(
                  labelText: 'Pilih Akun',
                  border: OutlineInputBorder(),
                ),
                items: controller.accounts.map((acc) {
                  return DropdownMenuItem<int>(
                    value: acc.id ?? 1,
                    child: Text(acc.name),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) selectedAccountId.value = val;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                key: ValueKey('cat_${selectedType.value}_${selectedCategoryId.value}'),
                initialValue: selectedCategoryId.value,
                decoration: const InputDecoration(
                  labelText: 'Pilih Kategori',
                  border: OutlineInputBorder(),
                ),
                items: filteredCategories.map((cat) {
                  return DropdownMenuItem<int>(
                    value: cat.id ?? 1,
                    child: Text(cat.name),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) selectedCategoryId.value = val;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Nominal (Rp)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          );
        },
      ),
      textConfirm: 'Simpan',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () {
        final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
        if (amount > 0) {
          controller.addTransaction(
            accountId: selectedAccountId.value,
            categoryId: selectedCategoryId.value,
            amount: amount,
            type: selectedType.value,
            date: DateTime.now(),
            note: noteController.text.trim(),
          );
        }
      },
    );
  }
}
