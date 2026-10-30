import 'package:equatable/equatable.dart';
import 'account_model.dart';
import 'category_model.dart';

enum TransactionType { income, expense, transfer }

class TransactionModel extends Equatable {
  final int? id;
  final int accountId;
  final int categoryId;
  final double amount;
  final TransactionType type;
  final DateTime date;
  final String? note;
  final String? receiptImagePath; // local file path

  const TransactionModel({
    this.id,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
    this.receiptImagePath,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
        id: json['id'] as int?,
        accountId: json['account_id'] as int,
        categoryId: json['category_id'] as int,
        amount: (json['amount'] as num).toDouble(),
        type: _typeFromString(json['type'] as String),
        date: DateTime.parse(json['date'] as String),
        note: json['note'] as String?,
        receiptImagePath: json['receipt_image_path'] as String?,
      );

  static TransactionType _typeFromString(String value) {
    switch (value) {
      case 'income':
        return TransactionType.income;
      case 'expense':
        return TransactionType.expense;
      case 'transfer':
        return TransactionType.transfer;
      default:
        return TransactionType.expense;
    }
  }

  String get typeString => type.name;

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'account_id': accountId,
        'category_id': categoryId,
        'amount': amount,
        'type': typeString,
        'date': date.toIso8601String(),
        if (note != null) 'note': note,
        if (receiptImagePath != null) 'receipt_image_path': receiptImagePath,
      };

  TransactionModel copyWith({
    int? id,
    int? accountId,
    int? categoryId,
    double? amount,
    TransactionType? type,
    DateTime? date,
    String? note,
    String? receiptImagePath,
  }) =>
      TransactionModel(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        categoryId: categoryId ?? this.categoryId,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        date: date ?? this.date,
        note: note ?? this.note,
        receiptImagePath: receiptImagePath ?? this.receiptImagePath,
      );

  @override
  List<Object?> get props => [
        id,
        accountId,
        categoryId,
        amount,
        type,
        date,
        note,
        receiptImagePath,
      ];
}
