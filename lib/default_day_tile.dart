import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';

class CalendarroDayItem extends StatelessWidget {
  const CalendarroDayItem({
    @required this.date,
    @required this.calendarroState,
    this.onTap,
    this.textColor,
    this.currentDayBorderColor,
    this.selectedDayColor,
  });

  final DateTime date;
  final CalendarroState calendarroState;
  final DateTimeCallback onTap;
  final Color textColor;
  final Color selectedDayColor;
  final Color currentDayBorderColor;

  @override
  Widget build(BuildContext context) {
    final bool isToday = DateUtils.isToday(date);

    final bool daySelected = calendarroState.isDateSelected(date);

    BoxDecoration boxDecoration;
    if (daySelected) {
      boxDecoration = BoxDecoration(
        color: selectedDayColor ?? Theme.of(context).accentColor,
        shape: BoxShape.circle,
      );
    } else if (isToday) {
      boxDecoration = BoxDecoration(
        border: Border.all(
          color: currentDayBorderColor ?? Theme.of(context).accentColor,
          width: 1.0,
        ),
        shape: BoxShape.circle,
      );
    }

    return Expanded(
      child: GestureDetector(
        child: Container(
          height: 40.0,
          decoration: boxDecoration,
          child: Center(
            child: Text(
              '${date.day}',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor ?? Colors.black,
              ),
            ),
          ),
        ),
        onTap: handleTap,
        behavior: HitTestBehavior.translucent,
      ),
    );
  }

  void handleTap() {
    if (onTap != null) {
      onTap(date);
    }

    calendarroState.setSelectedDate(date);
    calendarroState.setCurrentDate(date);
  }
}
