import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:flutter/material.dart';

class CalendarroPage extends StatelessWidget {

  static final MAX_ROWS_COUNT = 6;

  final DateTime pageStartDate;
  final DateTime pageEndDate;
  final Widget weekdayLabelsRow;
  final int curPage;
  final int startDayOffset;

  CalendarroPage({
    this.pageStartDate,
    this.pageEndDate,
    this.weekdayLabelsRow,
    this.curPage
  }) : this.startDayOffset = pageStartDate.weekday - DateTime.monday;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
            children: buildRows(context),
            mainAxisSize: MainAxisSize.min
        )
    );
  }

  List<Widget> buildRows(BuildContext context) {
    final List<Widget> rows = [];
    final state = Calendarro.of(context);
    if(state.widget.displayMode == DisplayMode.MONTHS) rows.add(state.widget.headerBuilder.build(context, "${pageStartDate.year}/${pageStartDate.month}", curPage));
    rows.add(weekdayLabelsRow);

    DateTime rowLastDayDate = DateUtils.addDaysToDate(pageStartDate, 6 - startDayOffset);

    if (pageEndDate.isAfter(rowLastDayDate)) {
      rows.add(Row(
          children: buildCalendarRow(context, pageStartDate, rowLastDayDate))
      );

      for (var i = 1; i < MAX_ROWS_COUNT; i++) {
        DateTime nextRowFirstDayDate = DateUtils.addDaysToDate(pageStartDate, 7 * i - startDayOffset);

        if (nextRowFirstDayDate.isAfter(pageEndDate)) {
          break;
        }

        DateTime nextRowLastDayDate = DateUtils.addDaysToDate(pageStartDate, 7 * i - startDayOffset + 6);


        if (nextRowLastDayDate.isAfter(pageEndDate)) {
          nextRowLastDayDate = pageEndDate;
        }

        rows.add(Row(
            children: buildCalendarRow(
                context, nextRowFirstDayDate, nextRowLastDayDate)));
      }
    } else {
      rows.add(Row(
          children: buildCalendarRow(context, pageStartDate, pageEndDate))
      );
    }

    return rows;
  }

  List<Widget> buildCalendarRow(
      BuildContext context, DateTime rowStartDate, DateTime rowEndDate) {
    final List<Widget> items = [];

    DateTime currentDate = rowStartDate;
    for (int i = 0; i < 7; i++) {
      if (i + 1 >= rowStartDate.weekday && i + 1 <= rowEndDate.weekday) {
        CalendarroState calendarroState = Calendarro.of(context);
          Widget dayTile = calendarroState.widget.dayTileBuilder
              .build(context, currentDate, calendarroState.widget.onTap);
          items.add(dayTile);
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
