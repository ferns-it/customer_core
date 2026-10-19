import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';

class TimeDropdownProvider extends ChangeNotifier {
  DateTime selectedDate = DateTime.now();
  String? selectedTime;
  List<String> timeSlots = [];

  bool get timeNotSelected => selectedTime == null;

  TimeOfDay? get selectedTimeAsTimeOfDay {
    if (selectedTime == null) return null;

    try {
      final isPm = selectedTime!.contains('PM');
      final timeParts =
          selectedTime!.replaceAll(' AM', '').replaceAll(' PM', '').split(':');

      final hour = int.parse(timeParts[0]) % 12 + (isPm ? 12 : 0);
      final minute = int.parse(timeParts[1]);

      return TimeOfDay(hour: hour, minute: minute);
    } catch (e) {
      // Handle potential errors in parsing
      return null;
    }
  }

  // Generate a list of time intervals
  void generateTimeSlots() {
    selectedTime = null;

    List<String> newTimeSlots = [];
    DateTime now = DateTime.now();

    // Check if the selected date is today
    bool isToday = DateFormat('yyyy-MM-dd').format(selectedDate) ==
        DateFormat('yyyy-MM-dd').format(now);

    // Align startTime and endTime to the same base date (e.g., 1970-01-01)
    DateTime startTime = isToday
        ? DateTime(0, 1, 1, now.hour, (now.minute + 14) ~/ 15 * 15)
        : DateTime(0, 1, 1, 0, 0);

    DateTime endTime = DateTime(0, 1, 1, 23, 45); // End at 11:45 PM

    while (startTime.isBefore(endTime) || startTime.isAtSameMomentAs(endTime)) {
      newTimeSlots.add(
          "${startTime.hour > 12 ? startTime.hour - 12 : startTime.hour == 0 ? 12 : startTime.hour}:${startTime.minute.toString().padLeft(2, '0')} ${startTime.hour >= 12 ? 'PM' : 'AM'}");
      startTime =
          startTime.add(const Duration(minutes: 15)); // Increment by 15 mins
    }

    timeSlots = newTimeSlots;
    notifyListeners();
  }

  void updateSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
    generateTimeSlots();
  }

  // Update selected time
  void updateSelectedTime(String? time) {
    selectedTime = time;
    notifyListeners();
  }

  void clearValues() {
    selectedDate = DateTime.now();
    selectedTime = null;
    notifyListeners();
  }
}
