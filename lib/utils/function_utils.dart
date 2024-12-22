import 'package:intl/intl.dart';

class Utils {
  static String formatDate(DateTime date, String format) {
    DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }

  static String formatTimeOfDay(time) {
    DateTime now = DateTime.now();
    DateTime dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return Utils.formatDate(dateTime, 'hh:mm a');
  }

  static int calculateDurationInMinutes(String startTime, String endTime) {
    final DateFormat timeFormat = DateFormat('hh:mm a');
    DateTime startDateTime = timeFormat.parse(startTime);
    DateTime endDateTime = timeFormat.parse(endTime);
    int durationInMinutes = endDateTime.difference(startDateTime).inMinutes;
    return durationInMinutes;
  }

  static String convertTo24HourFormat(String timeString) {
    DateFormat inputFormat = DateFormat.jm();
    DateTime dateTime = inputFormat.parse(timeString);
    DateFormat outputFormat = DateFormat.Hm();
    return outputFormat.format(dateTime);
  }
}
