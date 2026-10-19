import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

class DateTimeUtils {
  static String convertDateTimeToDate(DateTime? dateTime,
      [String format = "dd-MM-yyyy"]) {
    if (dateTime == null) return '';
    DateFormat dateFormat = DateFormat(format);
    return dateFormat.format(dateTime);
  }

  static TimeOfDay convertDateTimeToTimeOfDay(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  static String format(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String formatDateTimeToTime(DateTime dateTime) {
    return DateFormat('hh:mm:a').format(dateTime);
  }

  static String formatTimeOfDay(TimeOfDay timeOfDay) {
    return "${timeOfDay.hour}:${timeOfDay.minute.toString().padLeft(2, '0')}:00";
  }

  static String formatDateMinimal(String? inputDateString,
      [bool hideTime = false]) {
    if (inputDateString == null) return "";
    DateTime inputDate = DateTime.parse(inputDateString);
    final customDateFormat =
        hideTime ? DateFormat('E d, y') : DateFormat('E d, y hh:mm a');
    return customDateFormat.format(inputDate);
  }

  static String formatTimeMinimal(String? inputDateString) {
    if (inputDateString == null) return "";
    DateTime inputDate = DateTime.parse(inputDateString);
    final customDateFormat = DateFormat('hh:mm a');
    return customDateFormat.format(inputDate);
  }

  static String formatDateTimeToDate(String? dateTimeStr) {
    if (dateTimeStr == null) return '';
    // Parse the input date string to a DateTime object
    DateTime dateTime = DateTime.parse(dateTimeStr);

    // Format the DateTime object to the desired format
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);

    return formattedDate;
  }

  static DateTime combineDateTime(DateTime date, TimeOfDay time) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  static TimeOfDay addHoursToTime(TimeOfDay time, int hoursToAdd) {
    int newHour = time.hour + hoursToAdd;
    int newMinute = time.minute;

    // Handle overflow of hours (e.g., 23 + 1 becomes 0)
    newHour = newHour % 24;

    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  static String convert12HrTo24Hr(String originalTime) {
    // Parse the original time string to a DateTime object
    DateFormat inputFormat = DateFormat("hh:mm a");
    DateTime dateTime = inputFormat.parse(originalTime);

    // Format the DateTime object to the desired output format
    DateFormat outputFormat = DateFormat("HH:mm:ss");
    String convertedTime = outputFormat.format(dateTime);
    return convertedTime;
  }

  /// Adds a specified number of minutes to a [TimeOfDay].
  static TimeOfDay addMinutesToTime(TimeOfDay time, int minutesToAdd) {
    int totalMinutes = time.hour * 60 + time.minute + minutesToAdd;

    // Calculate new hour and minute
    int newHour =
        (totalMinutes ~/ 60) % 24; // Ensure hours wrap around after 24
    int newMinute = totalMinutes % 60; // Remainder is the new minute

    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  static String convertDateTime12HrTo24Hr(DateTime dateTime) {
    final DateFormat format24Hour = DateFormat("HH:mm:ss");
    return format24Hour.format(dateTime);
  }

  static String convert24HrTo12Hr(String time24) {
    // Parse the string into a DateTime object
    DateTime dateTime = DateFormat('HH:mm:ss').parse(time24);

    // Convert to 12-hour format
    String time12 = DateFormat('hh:mm a').format(dateTime);

    return time12;
  }
}
