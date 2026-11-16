import "../providers/local_db_provider.dart";
import "../models/transaction_model.dart";
import "transaction_repository.dart";

class TransactionRepositoryImpl implements TransactionRepository {
  final LocalDbProvider _dbProvider = LocalDbProvider();

  @override
  Future<List<TransactionModel>> getAllTransactions() async =>
      await _dbProvider.getAllTransactions();

  @override
  Future<int> insertTransaction(TransactionModel transaction) async =>
      await _dbProvider.insertTransaction(transaction);

  @override
  Future<int> updateTransaction(TransactionModel transaction) async =>
      await _dbProvider.updateTransaction(transaction);

  @override
  Future<int> deleteTransaction(int id) async =>
      await _dbProvider.deleteTransaction(id);
}
