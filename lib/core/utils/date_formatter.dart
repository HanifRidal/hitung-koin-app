import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Format tanggal standar: 29 Okt 2026
  static String formatShort(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  /// Format tanggal dengan hari: Kamis, 29 Oktober 2026
  static String formatFull(DateTime date) {
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
  }

  /// Format tanggal dan waktu: 29 Okt 2026, 14:30
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(date);
  }

  /// Format ISO 8601 untuk penyimpanan di SQLite: YYYY-MM-DD HH:MM:SS
  static String toDbString(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  /// Parse dari string SQLite ke DateTime
  static DateTime fromDbString(String str) {
    return DateTime.tryParse(str) ?? DateTime.now();
  }
}

