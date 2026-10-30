import 'package:equatable/equatable.dart';

class CurrencyModel extends Equatable {
  final int? id;
  final String code;
  final String symbol;
  final double exchangeRate;
  final bool isDefault;

  const CurrencyModel({
    this.id,
    required this.code,
    required this.symbol,
    required this.exchangeRate,
    this.isDefault = false,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        id: json['id'] as int?,
        code: json['code'] as String,
        symbol: json['symbol'] as String,
        exchangeRate: (json['exchange_rate'] as num).toDouble(),
        isDefault: (json['is_default'] as int?) == 1,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'code': code,
        'symbol': symbol,
        'exchange_rate': exchangeRate,
        'is_default': isDefault ? 1 : 0,
      };

  CurrencyModel copyWith({
    int? id,
    String? code,
    String? symbol,
    double? exchangeRate,
    bool? isDefault,
  }) =>
      CurrencyModel(
        id: id ?? this.id,
        code: code ?? this.code,
        symbol: symbol ?? this.symbol,
        exchangeRate: exchangeRate ?? this.exchangeRate,
        isDefault: isDefault ?? this.isDefault,
      );

  @override
  List<Object?> get props => [id, code, symbol, exchangeRate, isDefault];
}
