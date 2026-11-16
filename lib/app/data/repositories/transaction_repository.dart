import "../models/transaction_model.dart";

abstract class TransactionRepository {
  Future<List<TransactionModel>> getAllTransactions();
  Future<int> insertTransaction(TransactionModel transaction);
  Future<int> updateTransaction(TransactionModel transaction);
  Future<int> deleteTransaction(int id);
}
