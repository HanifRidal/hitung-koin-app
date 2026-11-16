import 'package:flutter_test/flutter_test.dart';
import 'package:hitung_koin_app/app/data/models/category_model.dart';

void main() {
  test('CategoryModel copyWith updates fields correctly', () {
    const original = CategoryModel(
      id: 1,
      name: 'Makanan',
      type: CategoryType.expense,
      icon: 'restaurant',
      colorHex: 'EF4444',
    );

    final updated = original.copyWith(
      name: 'Makan & Minum',
      icon: 'local_cafe',
      colorHex: 'F59E0B',
    );

    expect(updated.id, 1);
    expect(updated.name, 'Makan & Minum');
    expect(updated.type, CategoryType.expense);
    expect(updated.icon, 'local_cafe');
    expect(updated.colorHex, 'F59E0B');
  });
}
