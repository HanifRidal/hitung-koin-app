import 'package:equatable/equatable.dart';
import 'account_model.dart';
import 'category_model.dart';

enum RecurringFrequency { daily, weekly, monthly, yearly }

enum TransactionType { income, expense, transfer }

class RecurringTransactionModel extends Equatable {
  final int? id;
  final int accountId;
  final int categoryId;
  final double amount;
  final TransactionType type;
  final RecurringFrequency frequency;
  final DateTime nextRunDate;
  final String? note;
  final bool isActive;

  const RecurringTransactionModel({
    this.id,
    required this.accountId,
    required this.categoryId,
    required this.amount,
    required this.type,
    required this.frequency,
    required this.nextRunDate,
    this.note,
    this.isActive = true,
  });

  factory RecurringTransactionModel.fromJson(Map<String, dynamic> json) =>
      RecurringTransactionModel(
        id: json['id'] as int?,
        accountId: json['account_id'] as int,
        categoryId: json['category_id'] as int,
        amount: (json['amount'] as num).toDouble(),
        type: _typeFromString(json['type'] as String),
        frequency: _freqFromString(json['frequency'] as String),
        nextRunDate: DateTime.parse(json['next_run_date'] as String),
        note: json['note'] as String?,
        isActive: (json['is_active'] as int?) == 1,
      );

  static TransactionType _typeFromString(String v) {
    switch (v) {
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

  static RecurringFrequency _freqFromString(String v) {
    switch (v) {
      case 'daily':
        return RecurringFrequency.daily;
      case 'weekly':
        return RecurringFrequency.weekly;
      case 'monthly':
        return RecurringFrequency.monthly;
      case 'yearly':
        return RecurringFrequency.yearly;
      default:
        return RecurringFrequency.monthly;
    }
  }

  String get frequencyString => frequency.name;
  String get typeString => type.name;

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'account_id': accountId,
        'category_id': categoryId,
        'amount': amount,
        'type': typeString,
        'frequency': frequencyString,
        'next_run_date': nextRunDate.toIso8601String(),
        if (note != null) 'note': note,
        'is_active': isActive ? 1 : 0,
      };

  @override
  List<Object?> get props => [
        id,
        accountId,
        categoryId,
        amount,
        type,
        frequency,
        nextRunDate,
        note,
        isActive,
      ];
}
