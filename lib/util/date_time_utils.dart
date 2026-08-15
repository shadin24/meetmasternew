import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String kDateFormat = 'yyyy-MM-dd';

String formatDate(DateTime date) => DateFormat(kDateFormat).format(date);

String formatStoredDate(String storedDate) =>
    formatDate(DateTime.parse(storedDate));

String formatTimeOfDay(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:'
    '${time.minute.toString().padLeft(2, '0')}';

Future<DateTime?> pickDate(BuildContext context, DateTime? initialDate) {
  return showDatePicker(
    context: context,
    initialDate: initialDate ?? DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2101),
  );
}

Future<TimeOfDay?> pickTime(BuildContext context, TimeOfDay? initialTime) {
  return showTimePicker(
    context: context,
    initialTime: initialTime ?? TimeOfDay.now(),
  );
}
