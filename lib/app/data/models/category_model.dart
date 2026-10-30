import 'package:equatable/equatable.dart';

enum CategoryType { income, expense }

class CategoryModel extends Equatable {
  final int? id;
  final String name;
  final CategoryType type;
  final String? icon;
  final String? colorHex; // optional hex color string

  const CategoryModel({
    this.id,
    required this.name,
    required this.type,
    this.icon,
    this.colorHex,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as int?,
        name: json['name'] as String,
        type: json['type'] == 'income'
            ? CategoryType.income
            : CategoryType.expense,
        icon: json['icon'] as String?,
        colorHex: json['color'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        'type': type == CategoryType.income ? 'income' : 'expense',
        if (icon != null) 'icon': icon,
        if (colorHex != null) 'color': colorHex,
      };

  CategoryModel copyWith({
    int? id,
    String? name,
    CategoryType? type,
    String? icon,
    String? colorHex,
  }) =>
      CategoryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        icon: icon ?? this.icon,
        colorHex: colorHex ?? this.colorHex,
      );

  @override
  List<Object?> get props => [id, name, type, icon, colorHex];
}
