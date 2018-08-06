class DateUtils {
  static DateTime toMidnight(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static bool isWeekend(DateTime date) {
    return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
  }

  static bool isToday(DateTime date) {
    var now = DateTime.now();
    return date.day == now.day && date.month == now.month && date.year == now.year;
  }

  static bool isPastDay(DateTime date) {
    var today = toMidnight(DateTime.now());
    return date.isBefore(today);
  }

  static bool isSpecialPastDay(DateTime date) {
    return isPastDay(date) || (isToday(date) && DateTime.now().hour >= 12);
  }

  static DateTime getFirstDayOfCurrentMonth() {
    var dateTime = DateTime.now();
    dateTime = getFirstDayOfMonth(dateTime.month);
    return dateTime;
  }


  static DateTime getFirstDayOfMonth(int month) {
    var dateTime = DateTime.now();
    dateTime = DateTime(dateTime.year, month, 1);
    return dateTime;
  }

  static DateTime getFirstDayOfNextMonth() {
    var dateTime = getFirstDayOfCurrentMonth();
    dateTime = dateTime.add(Duration(days: 31));
    dateTime = DateTime(dateTime.year, dateTime.month, 1);
    return dateTime;
  }

  static DateTime getLastDayOfCurrentMonth() {
    return getFirstDayOfNextMonth().subtract(Duration(days: 1));
  }

  static DateTime getLastDayOfNextMonth() {
    var nextMonth = getFirstDayOfNextMonth()
        .add(Duration(days: 31));
    return DateTime(nextMonth.year, nextMonth.month, 1)
    .subtract(Duration(days: 1));
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.day == date2.day && date1.month == date2.month && date1.year == date2.year;
  }

  static bool isCurrentMonth(DateTime date) {
    var now = DateTime.now();
    return date.month == now.month && date.year == now.year;
  }
}