import 'package:intl/intl.dart';

abstract final class CurrencyFormatter {
  static final _formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String format(num amount) => _formatter.format(amount);
}
