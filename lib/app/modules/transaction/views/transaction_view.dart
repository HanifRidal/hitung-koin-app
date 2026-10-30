import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/values/app_strings.dart';
import '../controllers/transaction_controller.dart';

class TransactionView extends GetView<TransactionController> {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.navTransactions),
      ),
      body: const Center(
        child: Text('Daftar Transaksi'),
      ),
    );
  }
}

