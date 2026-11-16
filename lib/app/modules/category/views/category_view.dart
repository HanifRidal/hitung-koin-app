import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
    var clean = hex.replaceAll('#', '').trim();
    if (clean.length == 3) {
      clean = clean.split('').map((c) => '$c$c').join();
    }
    if (clean.length > 6) {
      clean = clean.substring(0, 6);
    }
    final val = int.tryParse('FF$clean', radix: 16);
    return val != null ? Color(val) : AppColors.primary;
  }

  static String colorToHex(Color color) {
    final v = color.toARGB32() & 0x00FFFFFF;
    return v.toRadixString(16).padLeft(6, '0').toUpperCase();
  }

  static Widget buildCategoryIcon(String? icon, Color color) {
    if (icon != null && (icon.endsWith('.svg') || icon.startsWith('/') || icon.contains(r'\'))) {
      final file = File(icon);
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        final match = RegExp(r'''d=["'']([^"'']+)["'']''').firstMatch(content);
        if (match != null) {
          return SizedBox(
            width: 22,
            height: 22,
            child: CustomPaint(painter: _SvgPathPainter(match.group(1)!, color)),
          );
        }
      }
      return Icon(Icons.insert_drive_file_outlined, color: color, size: 20);
    }
    return Icon(iconFromName(icon), color: color, size: 22);
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
            if (list.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.drag_indicator, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Tahan & geser ikon untuk mengatur urutan', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
            Expanded(
              child: list.isEmpty
                  ? const Center(child: Text('Tidak ada kategori'))
                  : ReorderableListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: list.length,
                      buildDefaultDragHandles: false,
                      onReorder: controller.reorderCategories,
                      itemBuilder: (context, i) {
                        final cat = list[i];
                        final color = colorFromHex(cat.colorHex);
                        return Card(
                          key: ValueKey(cat.id ?? 'cat_$i'),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ReorderableDragStartListener(
                                  index: i,
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 8),
                                    child: Icon(Icons.drag_handle_rounded, color: Colors.grey),
                                  ),
                                ),
                                CircleAvatar(
                                  backgroundColor: color.withValues(alpha: 0.15),
                                  child: buildCategoryIcon(cat.icon, color),
                                ),
                              ],
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

    final hexCtrl = TextEditingController(text: '#${colorObs.value}');

    final initialColor = colorFromHex(colorObs.value);
    final hsv = HSVColor.fromColor(initialColor);
    final hueObs = hsv.hue.obs;
    final satObs = hsv.saturation.obs;
    final valObs = hsv.value.obs;

    void onHsvChanged() {
      final c = HSVColor.fromAHSV(1.0, hueObs.value, satObs.value, valObs.value).toColor();
      final hex = colorToHex(c);
      colorObs.value = hex;
      hexCtrl.text = '#$hex';
    }

    void onHexInputChanged(String text) {
      final clean = text.replaceAll('#', '').trim();
      if (clean.length == 3 || clean.length == 6) {
        final c = colorFromHex(clean);
        colorObs.value = colorToHex(c);
        final newHsv = HSVColor.fromColor(c);
        hueObs.value = newHsv.hue;
        satObs.value = newHsv.saturation;
        valObs.value = newHsv.value;
      }
    }

    Get.defaultDialog(
      title: existing == null ? 'Tambah Kategori' : 'Ubah Kategori',
      content: Obx(() {
        final currentColor = colorFromHex(colorObs.value);

        return SingleChildScrollView(
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
                        if (v) typeObs.value = CategoryType.expense;
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
                        if (v) typeObs.value = CategoryType.income;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Input Kode HEX (#FFFFFF)
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: currentColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: hexCtrl,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[#a-fA-F0-9]')),
                        LengthLimitingTextInputFormatter(7),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Kode HEX Warna (cth: #FFFFFF)',
                        hintText: '#FFFFFF',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onChanged: onHexInputChanged,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Slider HSV Penyesuai Warna
              _sliderRow('Hue', hueObs.value, 0, 360, (v) {
                hueObs.value = v;
                onHsvChanged();
              }),
              _sliderRow('Sat', satObs.value, 0, 1, (v) {
                satObs.value = v;
                onHsvChanged();
              }),
              _sliderRow('Val', valObs.value, 0, 1, (v) {
                valObs.value = v;
                onHsvChanged();
              }),
              const SizedBox(height: 12),
              const Text('Pilih Ikon Bawaan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: CategoryController.availableIcons.map((ic) {
                  final isSel = iconObs.value == ic;
                  return GestureDetector(
                    onTap: () => iconObs.value = ic,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: isSel ? AppColors.primaryLight : Colors.grey.shade200,
                      child: Icon(iconFromName(ic), size: 16, color: isSel ? AppColors.primaryDark : Colors.grey.shade700),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                icon: const Icon(Icons.file_upload_outlined, size: 16),
                label: Text(
                  iconObs.value.endsWith('.svg')
                      ? 'SVG: ${iconObs.value.split(RegExp(r"[/\\]")).last}'
                      : 'Upload File SVG',
                  style: const TextStyle(fontSize: 11),
                  overflow: TextOverflow.ellipsis,
                ),
                onPressed: () async {
                  final picker = ImagePicker();
                  final picked = await picker.pickMedia();
                  if (picked != null && picked.path.toLowerCase().endsWith('.svg')) {
                    iconObs.value = picked.path;
                  } else if (picked != null) {
                    Get.snackbar('Format Salah', 'Harap pilih file berekstensi .svg');
                  }
                },
              ),
            ],
          ),
        );
      }),
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

  Widget _sliderRow(String label, double val, double min, double max, ValueChanged<double> onChanged) {
    return Row(
      children: [
        SizedBox(width: 32, child: Text(label, style: const TextStyle(fontSize: 11))),
        Expanded(
          child: Slider(
            value: val.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _SvgPathPainter extends CustomPainter {
  final String pathData;
  final Color color;

  _SvgPathPainter(this.pathData, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final tokens = pathData.split(RegExp(r'[\s,]+'));
    int i = 0;
    while (i < tokens.length) {
      final token = tokens[i];
      if (token == 'M' && i + 2 < tokens.length) {
        path.moveTo(double.tryParse(tokens[i + 1]) ?? 0, double.tryParse(tokens[i + 2]) ?? 0);
        i += 3;
      } else if (token == 'L' && i + 2 < tokens.length) {
        path.lineTo(double.tryParse(tokens[i + 1]) ?? 0, double.tryParse(tokens[i + 2]) ?? 0);
        i += 3;
      } else if (token == 'Z' || token == 'z') {
        path.close();
        i += 1;
      } else {
        i += 1;
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SvgPathPainter oldDelegate) =>
      oldDelegate.pathData != pathData || oldDelegate.color != color;
}
