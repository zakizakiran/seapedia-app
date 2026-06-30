import 'package:intl/intl.dart';

extension NumCurrencyExtension on num {
  String get toRp {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    ).format(this);
  }
}
