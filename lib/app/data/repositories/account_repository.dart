import '../models/account_model.dart';

abstract class AccountRepository {
  Future<List<AccountModel>> getAllAccounts();
  Future<int> insertAccount(AccountModel account);
  Future<int> updateAccount(AccountModel account);
  Future<int> deleteAccount(int id);
}
