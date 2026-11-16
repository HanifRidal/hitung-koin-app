import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../data/models/category_model.dart';
import '../controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  static IconData iconFromName(String? name) {
    switch (name) {
      case 'payments': return Icons.payments_rounded;
      case 'restaurant': return Icons.restaurant_rounded;
      case 'directions_car': return Icons.directions_car_rounded;
      case 'shopping_bag': return Icons.shopping_bag_rounded;
      case 'receipt': return Icons.receipt_rounded;
      case 'work': return Icons.work_rounded;
      case 'flight': return Icons.flight_rounded;
      case 'school': return Icons.school_rounded;
      case 'fitness_center': return Icons.fitness_center_rounded;
      default: return Icons.category_rounded;
    }
  }

  static Color colorFromHex(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.primary;
    final val = int.tryParse('FF$hex', radix: 16);
    return val != null ? Color(val) : AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
        centerTitle: false,
      ),
      body: Obx(() {
        final list = controller.filteredCategories;
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Semua'),
                    selected: controller.selectedFilter.value == null,
                    onSelected: (_) => controller.selectedFilter.value = null,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Pengeluaran'),
                    selected: controller.selectedFilter.value == CategoryType.expense,
                    selectedColor: Colors.red.shade100,
                    onSelected: (_) => controller.selectedFilter.value = CategoryType.expense,
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: const Text('Pemasukan'),
                    selected: controller.selectedFilter.value == CategoryType.income,
                    selectedColor: AppColors.primaryLight,
                    onSelected: (_) => controller.selectedFilter.value = CategoryType.income,
                  ),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text('Tidak ada kategori'))
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: list.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 6),
                      itemBuilder: (context, i) {
                        final cat = list[i];
                        final color = colorFromHex(cat.colorHex);
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: color.withOpacity(0.15),
                              child: Icon(iconFromName(cat.icon), color: color),
                            ),
                            title: Text(cat.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            subtitle: Text(cat.type == CategoryType.income ? 'Pemasukan' : 'Pengeluaran'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, size: 20),
                                  onPressed: () => _showFormDialog(context, existing: cat),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                                  onPressed: () {
                                    if (cat.id != null) controller.deleteCategory(cat.id!);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showFormDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showFormDialog(BuildContext context, {CategoryModel? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final typeObs = (existing?.type ?? CategoryType.expense).obs;
    final colorObs = (existing?.colorHex ?? 'EF4444').obs;
    final iconObs = (existing?.icon ?? 'category').obs;

    Get.defaultDialog(
      title: existing == null ? 'Tambah Kategori' : 'Ubah Kategori',
      content: Obx(() => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Kategori', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(child: Text('Pengeluaran')),
                        selected: typeObs.value == CategoryType.expense,
                        selectedColor: Colors.red.shade100,
                        onSelected: (v) {
                          if (v) {
                            typeObs.value = CategoryType.expense;
                            if (existing == null) colorObs.value = 'EF4444';
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Center(child: Text('Pemasukan')),
                        selected: typeObs.value == CategoryType.income,
                        selectedColor: AppColors.primaryLight,
                        onSelected: (v) {
                          if (v) {
                            typeObs.value = CategoryType.income;
                            if (existing == null) colorObs.value = '10B981';
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('Pilih Warna', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: CategoryController.availableColors.map((hex) {
                    final c = colorFromHex(hex);
                    final isSel = colorObs.value == hex;
                    return GestureDetector(
                      onTap: () => colorObs.value = hex,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: c,
                        child: isSel ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                const Text('Pilih Ikon', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: CategoryController.availableIcons.map((ic) {
                    final isSel = iconObs.value == ic;
                    return GestureDetector(
                      onTap: () => iconObs.value = ic,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: isSel ? AppColors.primaryLight : Colors.grey.shade200,
                        child: Icon(iconFromName(ic), size: 18, color: isSel ? AppColors.primaryDark : Colors.grey.shade700),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          )),
      textConfirm: 'Simpan',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primary,
      onConfirm: () {
        final name = nameCtrl.text.trim();
        if (name.isEmpty) return;
        if (existing == null) {
          controller.addCategory(
            name: name,
            type: typeObs.value,
            colorHex: colorObs.value,
            icon: iconObs.value,
          );
        } else {
          controller.updateCategory(
            existing.copyWith(
              name: name,
              type: typeObs.value,
              colorHex: colorObs.value,
              icon: iconObs.value,
            ),
          );
        }
        Get.back();
      },
    );
  }
}
