import 'package:get/get.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/models/account_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../data/repositories/transaction_repository_impl.dart';
import '../../../data/repositories/account_repository.dart';
import '../../../data/repositories/account_repository_impl.dart';
import '../../../data/providers/local_db_provider.dart';

class TransactionController extends GetxController {
  final TransactionRepository _transactionRepo = TransactionRepositoryImpl();
  final AccountRepository _accountRepo = AccountRepositoryImpl();
  final LocalDbProvider _dbProvider = LocalDbProvider();

  final transactions = <TransactionModel>[].obs;
  final accounts = <AccountModel>[].obs;
  final categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    await Future.wait([
      loadTransactions(),
      loadAccounts(),
      loadCategories(),
    ]);
  }

  Future<void> loadTransactions() async {
    try {
      final list = await _transactionRepo.getAllTransactions();
      transactions.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat transaksi: $e');
    }
  }

  Future<void> loadAccounts() async {
    try {
      final list = await _accountRepo.getAllAccounts();
      accounts.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat akun: $e');
    }
  }

  Future<void> loadCategories() async {
    try {
      final list = await _dbProvider.getAllCategories();
      categories.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat kategori: $e');
    }
  }

  String getCategoryName(int categoryId) {
    return categories.firstWhereOrNull((c) => c.id == categoryId)?.name ?? 'Umum';
  }

  List<CategoryModel> categoriesForType(TransactionType type) {
    final catType = type == TransactionType.income ? CategoryType.income : CategoryType.expense;
    return categories.where((c) => c.type == catType).toList();
  }

  Future<void> addTransaction({
    required int accountId,
    required int categoryId,
    required double amount,
    required TransactionType type,
    required DateTime date,
    String? note,
    String? receiptImagePath,
  }) async {
    try {
      final txn = TransactionModel(
        accountId: accountId,
        categoryId: categoryId,
        amount: amount,
        type: type,
        date: date,
        note: note,
        receiptImagePath: receiptImagePath,
      );

      await _transactionRepo.insertTransaction(txn);

      final acc = accounts.firstWhereOrNull((a) => a.id == accountId);
      if (acc != null) {
        double newBalance = acc.balance;
        if (type == TransactionType.income) {
          newBalance += amount;
        } else if (type == TransactionType.expense) {
          newBalance -= amount;
        }
        await _accountRepo.updateAccount(acc.copyWith(balance: newBalance));
      }

      await loadTransactions();
      await loadAccounts();
      Get.back();
      Get.snackbar('Sukses', 'Transaksi berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan transaksi: $e');
    }
  }

  Future<void> deleteTransaction(TransactionModel txn) async {
    try {
      if (txn.id == null) return;
      await _transactionRepo.deleteTransaction(txn.id!);

      final acc = accounts.firstWhereOrNull((a) => a.id == txn.accountId);
      if (acc != null) {
        double newBalance = acc.balance;
        if (txn.type == TransactionType.income) {
          newBalance -= txn.amount;
        } else if (txn.type == TransactionType.expense) {
          newBalance += txn.amount;
        }
        await _accountRepo.updateAccount(acc.copyWith(balance: newBalance));
      }

      await loadTransactions();
      await loadAccounts();
      Get.snackbar('Sukses', 'Transaksi berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus transaksi: $e');
    }
  }
}
