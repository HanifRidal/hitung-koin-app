import 'package:get/get.dart';
import '../../../data/models/category_model.dart';
import '../../../data/providers/local_db_provider.dart';

class CategoryController extends GetxController {
  final LocalDbProvider _dbProvider = LocalDbProvider();

  final categories = <CategoryModel>[].obs;
  final selectedFilter = Rxn<CategoryType>();

  static const availableIcons = [
    'category',
    'payments',
    'restaurant',
    'directions_car',
    'shopping_bag',
    'receipt',
    'work',
    'flight',
    'school',
    'fitness_center',
  ];

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      final list = await _dbProvider.getAllCategories();
      categories.assignAll(list);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat kategori: $e');
    }
  }

  List<CategoryModel> get filteredCategories {
    if (selectedFilter.value == null) return categories;
    return categories.where((c) => c.type == selectedFilter.value).toList();
  }

  Future<void> addCategory({
    required String name,
    required CategoryType type,
    String? icon,
    String? colorHex,
  }) async {
    final cat = CategoryModel(
      name: name,
      type: type,
      icon: icon ?? 'category',
      colorHex: colorHex ?? (type == CategoryType.income ? '10B981' : 'EF4444'),
      sortOrder: categories.length,
    );
    await _dbProvider.insertCategory(cat);
    await loadCategories();
  }

  Future<void> updateCategory(CategoryModel cat) async {
    if (cat.id == null) return;
    await _dbProvider.updateCategory(cat);
    await loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _dbProvider.deleteCategory(id);
    await loadCategories();
  }

  Future<void> reorderCategories(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;

    // Filter-aware reordering: mapping index filtered ke list utama
    final currentFiltered = filteredCategories;
    final movedItem = currentFiltered[oldIndex];
    final targetItem = currentFiltered[newIndex];

    final globalOld = categories.indexWhere((c) => c.id == movedItem.id);
    final globalTarget = categories.indexWhere((c) => c.id == targetItem.id);

    if (globalOld == -1 || globalTarget == -1) return;

    categories.removeAt(globalOld);
    categories.insert(globalTarget, movedItem);

    await _dbProvider.updateCategoryOrders(categories);
  }
}
