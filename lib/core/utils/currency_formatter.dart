import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  /// Format angka menjadi format Rupiah atau simbol kustom, misal: Rp 50.000
  static String format(
    num amount, {
    String symbol = 'Rp',
    int decimalDigits = 0,
  }) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: symbol.isNotEmpty ? '$symbol ' : '',
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  /// Format angka ringkas untuk statistik/chart (misal: 1.5jt, 250rb)
  static String formatCompact(num amount, {String symbol = 'Rp '}) {
    if (amount >= 1000000000) {
      return '$symbol${(amount / 1000000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000000) {
      return '$symbol${(amount / 1000000).toStringAsFixed(1)}Jt';
    } else if (amount >= 1000) {
      return '$symbol${(amount / 1000).toStringAsFixed(0)}Rb';
    }
    return '$symbol$amount';
  }
}

