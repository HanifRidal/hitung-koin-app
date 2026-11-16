import "../../../data/models/account_model.dart";
import "../../../data/repositories/account_repository.dart";
import "../../../data/repositories/account_repository_impl.dart";
import "package:get/get.dart";

class HomeController extends GetxController {
  final AccountRepository _accountRepo = AccountRepositoryImpl();

  var accounts = <AccountModel>[].obs;

  double get totalBalance => accounts.fold(0.0, (sum, a) => sum + a.balance);

  @override
  void onInit() {
    super.onInit();
    loadAccounts();
  }

  Future<void> loadAccounts() async {
    try {
      final list = await _accountRepo.getAllAccounts();
      accounts.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load accounts: $e');
    }
  }

  Future<void> addAccount(AccountModel account) async {
    await _accountRepo.insertAccount(account);
    await loadAccounts();
  }

  Future<void> updateAccount(AccountModel account) async {
    if (account.id != null) {
      await _accountRepo.updateAccount(account);
      await loadAccounts();
    }
  }

  Future<void> deleteAccount(int id) async {
    await _accountRepo.deleteAccount(id);
    await loadAccounts();
  }
}
