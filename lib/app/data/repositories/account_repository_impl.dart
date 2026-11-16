import '../providers/local_db_provider.dart';
import '../models/account_model.dart';
import 'account_repository.dart';

class AccountRepositoryImpl implements AccountRepository {
  final LocalDbProvider _dbProvider = LocalDbProvider();

  @override
  Future<List<AccountModel>> getAllAccounts() async =>
      await _dbProvider.getAllAccounts();

  @override
  Future<int> insertAccount(AccountModel account) async =>
      await _dbProvider.insertAccount(account);

  @override
  Future<int> updateAccount(AccountModel account) async =>
      await _dbProvider.updateAccount(account);

  @override
  Future<int> deleteAccount(int id) async => await _dbProvider.deleteAccount(id);
}
