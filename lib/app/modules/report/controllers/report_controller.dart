import "package:get/get.dart";
import "../../../data/repositories/transaction_repository.dart";
import "../../../data/repositories/transaction_repository_impl.dart";
import "../../../data/models/transaction_model.dart";
import "../../../data/models/account_model.dart";
import "../../../data/models/category_model.dart";
import "../../../data/providers/local_db_provider.dart";

class ReportController extends GetxController {
  final TransactionRepository _transactionRepo = TransactionRepositoryImpl();
  final LocalDbProvider _dbProvider = LocalDbProvider();

  var transactions = <TransactionModel>[].obs;
  var accounts = <AccountModel>[].obs;
  var categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await Future.wait([
      _loadTransactions(),
      _loadAccounts(),
      _loadCategories(),
    ]);
  }

  Future<void> _loadTransactions() async {
    try {
      final list = await _transactionRepo.getAllTransactions();
      transactions.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat transaksi: $e');
    }
  }

  Future<void> _loadAccounts() async {
    try {
      final list = await _dbProvider.getAllAccounts();
      accounts.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', "Gagal memuat akun: $e");
    }
  }

  Future<void> _loadCategories() async {
    try {
      final list = await _dbProvider.getAllCategories();
      categories.assignAll(list);
    } catch (e) {
      Get.snackbar("Error", "Gagal memuat kategori: $e");
    }
  }
}
