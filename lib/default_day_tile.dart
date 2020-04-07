import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class CalendarroDayItem extends StatelessWidget {
  CalendarroDayItem({
    this.date,
    this.calendarroState,
    this.onTap,
    this.backgroundColor = Colors.black,
    this.selectedColor = Colors.blue,
    this.textColor = Colors.white,
    this.weekEndColor = Colors.red,
    this.fontFamily,
    this.fontSize,
  });

  final DateTime date;
  final CalendarroState calendarroState;
  final DateTimeCallback onTap;
  final Color backgroundColor;
  final Color selectedColor;
  final Color textColor;
  final Color weekEndColor;
  final String fontFamily;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    bool isWeekend = DateUtils.isWeekend(date);
    var color = isWeekend ? weekEndColor : textColor;
    bool isToday = DateUtils.isToday(date);

    bool daySelected = calendarroState.isDateSelected(date);

    BoxDecoration boxDecoration;
    if (daySelected) {
      boxDecoration =
          BoxDecoration(color: selectedColor, shape: BoxShape.circle);
    } else if (isToday) {
      boxDecoration = BoxDecoration(
        border: Border.all(
          color: color,
          width: 1.0,
        ),
        shape: BoxShape.circle,
      );
    }

    return Expanded(
      child: GestureDetector(
        child: Container(
          decoration: boxDecoration,
          child: Center(
            child: Padding(
              padding: EdgeInsetsResponsive.all(
                16.0,
              ),
              child: TextResponsive(
                "${date.day}",
                textAlign: TextAlign.center,
                style: _getTextStyle(color: color),
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
      onTap(date, !calendarroState.isDateSelected(date));
    }

    calendarroState.setSelectedDate(date);
    calendarroState.setCurrentDate(date);
  }

  TextStyle _getTextStyle({Color color}) {
    TextStyle style = TextStyle(
      color: color,
    );

    if (fontSize != null) {
      style = style.copyWith(
        fontSize: fontSize,
      );
    }

    if (fontFamily != null) {
      style = style.copyWith(
        fontFamily: fontFamily,
      );
    }

    return style;
  }
}
