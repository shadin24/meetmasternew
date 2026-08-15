import 'package:intl/intl.dart';

class Utils {
  static bool isValidEmail(String email) {
    // Define a regular expression for email validation
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );

    // Check if the email matches the regular expression
    return emailRegex.hasMatch(email);
  }
}

/// Formats a stored meeting date, falling back to the raw value when it cannot
/// be parsed so an unexpected format never crashes the widget tree.
String formatMeetingDate(String rawDate) {
  final date = DateTime.tryParse(rawDate);
  if (date == null) {
    return rawDate;
  }
  return DateFormat('yyyy-MM-dd').format(date);
}
