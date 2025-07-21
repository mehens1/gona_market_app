import 'package:intl/intl.dart';

class Formatters {
  // Date only formatter (e.g. 2024-06-10)
  static String formatDate(DateTime date) {
    final formatter = DateFormat('dd MMMM, yyyy');
    return formatter.format(date);
  }

  // Date and time formatter (e.g. 2024-06-10 14:30)
  static String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd MMMM, yyyy - HH:mm');
    return formatter.format(dateTime);
  }

  // Number formatter (e.g. 1,234,567)
  static String formatNumber(num number) {
    final formatter = NumberFormat('#,##0');
    return formatter.format(number);
  }

  // Currency formatter (e.g. ₦1,234.56)
  static String formatCurrency(num amount,
      {String locale = 'en_NG', String symbol = '₦'}) {
    final formatter = NumberFormat.currency(locale: locale, symbol: symbol);
    return formatter.format(amount);
  }
}
