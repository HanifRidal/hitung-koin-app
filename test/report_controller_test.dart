import 'package:flutter_test/flutter_test.dart';
import 'package:hitung_koin_app/app/data/models/transaction_model.dart';

void main() {
  test('calculated income and expense totals match', () {
    final txns = [
      TransactionModel(
        id: 1,
        accountId: 1,
        categoryId: 1,
        amount: 50000,
        type: TransactionType.income,
        date: DateTime.now(),
      ),
      TransactionModel(
        id: 2,
        accountId: 1,
        categoryId: 1,
        amount: 20000,
        type: TransactionType.expense,
        date: DateTime.now(),
      ),
    ];

    final income = txns
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (s, t) => s + t.amount);
    final expense = txns
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (s, t) => s + t.amount);

    expect(income, 50000.0);
    expect(expense, 20000.0);
    expect(income - expense, 30000.0);
  });
}
