import 'package:calendarro/Calendarro.dart';
import 'package:calendarro/CalendarroDayItem.dart';
import 'package:calendarro/CalendarroWeekdayLabelsView.dart';
import 'package:flutter/material.dart';

class CalendarroPage extends StatelessWidget {
  CalendarroPage({
    this.pageStartDate,
    this.pageEndDate,
  });

  DateTime pageStartDate;
  DateTime pageEndDate;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.min, children: buildRows(context)));
  }

  List<Widget> buildRows(BuildContext context) {
    List<Widget> rows = [];
    rows.add(CalendarroWeekdayLabelsView());

    int startDayOffset = pageStartDate.weekday - DateTime.monday;
    DateTime weekLastDayDate =
    pageStartDate.add(Duration(days: 6 - startDayOffset));

    if (pageEndDate.isAfter(weekLastDayDate)) {
      rows.add(Row(
          children: buildCalendarRow(context, pageStartDate, weekLastDayDate)));

      for (var i = 1; i < 6; i++) {
        DateTime nextWeekFirstDayDate =
        pageStartDate.add(Duration(days: 7 * i - startDayOffset));

        if (nextWeekFirstDayDate.isAfter(pageEndDate)) {
          break;
        }

        DateTime nextWeekLastDayDate =
        pageStartDate.add(Duration(days: 7 * i - startDayOffset + 6));
        if (nextWeekLastDayDate.isAfter(pageEndDate)) {
          nextWeekLastDayDate = pageEndDate;
        }

        rows.add(Row(
            children: buildCalendarRow(
                context, nextWeekFirstDayDate, nextWeekLastDayDate)));
      }
    } else {
      rows.add(Row(
          children: buildCalendarRow(context, pageStartDate, pageEndDate)));
    }

    return rows;
  }

  List<Widget> buildCalendarRow(
      BuildContext context, DateTime rowStartDate, DateTime rowEndDate) {
    List<Widget> items = [];

    DateTime currentDate = rowStartDate;
    for (int i = 0; i < 7; i++) {
      if (i + 1 >= rowStartDate.weekday && i + 1 <= rowEndDate.weekday) {
        CalendarroState calendarro = Calendarro.of(context);
//        if (calendarro.widget.dayTileBuilder != null) {
          Widget dayTile = calendarro.widget.dayTileBuilder.build(context, currentDate);
          items.add(dayTile);
//        } else {
//          items.add(CalendarroDayItem(date: currentDate));
//        }
        currentDate = currentDate.add(Duration(days: 1));
      } else {
        items.add(Expanded(
          child: Text(""),
        ));
      }
    }

    return items;
  }
}