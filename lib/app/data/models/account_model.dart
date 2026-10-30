import 'package:equatable/equatable.dart';

class AccountModel extends Equatable {
  final int? id;
  final String name;
  final double balance;
  final String? icon;
  final String currencyCode;

  const AccountModel({
    this.id,
    required this.name,
    this.balance = 0.0,
    this.icon,
    this.currencyCode = 'IDR',
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
        id: json['id'] as int?,
        name: json['name'] as String,
        balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
        icon: json['icon'] as String?,
        currencyCode: json['currency_code'] as String? ?? 'IDR',
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'name': name,
        'balance': balance,
        if (icon != null) 'icon': icon,
        'currency_code': currencyCode,
      };

  AccountModel copyWith({
    int? id,
    String? name,
    double? balance,
    String? icon,
    String? currencyCode,
  }) =>
      AccountModel(
        id: id ?? this.id,
        name: name ?? this.name,
        balance: balance ?? this.balance,
        icon: icon ?? this.icon,
        currencyCode: currencyCode ?? this.currencyCode,
      );

  @override
  List<Object?> get props => [id, name, balance, icon, currencyCode];
}
