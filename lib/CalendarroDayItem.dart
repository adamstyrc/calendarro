import 'package:calendarro/Calendarro.dart';
import 'package:calendarro/DateUtils.dart';
import 'package:flutter/material.dart';

class CalendarroDayItem extends StatelessWidget {
  CalendarroDayItem({this.date, this.calendarro});

  DateTime date;
  CalendarroState calendarro;
  int count = 0;
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    context = context;
    bool isWeekend = DateUtils.isWeekend(date);
    var textColor = isWeekend ? Colors.grey : Colors.black;
    bool isToday = DateUtils.isToday(date);
    calendarro = Calendarro.of(context) as CalendarroState;

    bool isSelected = calendarro.isDateSelected(date);

    BoxDecoration boxDecoration;
    if (isSelected) {
      boxDecoration =
      BoxDecoration(color: Colors.white, shape: BoxShape.circle);
    } else if (isToday) {
      boxDecoration = BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          shape: BoxShape.circle);
    }

    return Expanded(
        child: GestureDetector(
          child: Container(
              height: 40.0,
              decoration: boxDecoration,
              child: Center(
                  child: Text(
                    "${date.day}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textColor),
                  ))),
          onTap: handleTap,
        ));
  }

  void handleTap() {
    calendarro.setSelectedDate(date);
    calendarro.setCurrentDate(date);
  }
}