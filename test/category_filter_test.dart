import 'package:flutter_test/flutter_test.dart';
import 'package:hitung_koin_app/app/data/models/category_model.dart';
import 'package:hitung_koin_app/app/data/models/transaction_model.dart';

void main() {
  test('filter categories by transaction type matches', () {
    const list = [
      CategoryModel(id: 1, name: 'Gaji', type: CategoryType.income),
      CategoryModel(id: 2, name: 'Makan', type: CategoryType.expense),
      CategoryModel(id: 3, name: 'Bonus', type: CategoryType.income),
    ];

    List<CategoryModel> forType(TransactionType t) {
      final ct = t == TransactionType.income ? CategoryType.income : CategoryType.expense;
      return list.where((c) => c.type == ct).toList();
    }

    expect(forType(TransactionType.income).map((c) => c.name), ['Gaji', 'Bonus']);
    expect(forType(TransactionType.expense).map((c) => c.name), ['Makan']);
  });
}
