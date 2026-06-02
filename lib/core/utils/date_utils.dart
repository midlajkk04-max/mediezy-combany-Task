import 'package:intl/intl.dart';

class DateFormatUtils {
  DateFormatUtils._();

  static final DateFormat apiFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat displayFormat = DateFormat('dd MMM yyyy');
  static final DateFormat monthYearFormat = DateFormat('MMMM yyyy');

  static String formatForApi(DateTime date) {
    return apiFormat.format(date);
  }

  static String formatForDisplay(DateTime date) {
    return displayFormat.format(date);
  }

  static String formatMonthYear(DateTime date) {
    return monthYearFormat.format(date);
  }

  static String currentMonth() {
    return DateFormat('MM').format(DateTime.now());
  }

  static List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  static String monthNumber(String monthName) {
    final index = months.indexOf(monthName);
    if (index == -1) return '01';
    return (index + 1).toString().padLeft(2, '0');
  }

  static String monthName(String monthNumber) {
    final index = int.tryParse(monthNumber);
    if (index == null || index < 1 || index > 12) return '';
    return months[index - 1];
  }
}
