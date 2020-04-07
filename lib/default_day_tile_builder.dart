import 'package:calendarro/calendarro.dart';
import 'package:calendarro/default_day_tile.dart';
import 'package:flutter/material.dart';

class DefaultDayTileBuilder extends DayTileBuilder {
  DefaultDayTileBuilder();

  @override
  Widget build(BuildContext context, DateTime date, DateTimeCallback onTap) {
    return CalendarroDayItem(
      date: date,
      calendarroState: Calendarro.of(context),
      onTap: onTap,
      textColor: Colors.white,
      weekEndColor: Colors.red,
      selectedColor: Colors.green,
      fontSize: 30,
    );
  }
}
