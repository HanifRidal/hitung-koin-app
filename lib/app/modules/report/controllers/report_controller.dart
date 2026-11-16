import 'package:get/get.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../data/repositories/transaction_repository_impl.dart';

class ReportController extends GetxController {
  final TransactionRepository _transactionRepo = TransactionRepositoryImpl();

  final transactions = <TransactionModel>[].obs;

  double get totalIncome => transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final list = await _transactionRepo.getAllTransactions();
      transactions.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat transaksi: $e');
    }
  }
}
