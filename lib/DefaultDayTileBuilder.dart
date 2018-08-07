import 'package:calendarro/Calendarro.dart';
import 'package:calendarro/CalendarroDayItem.dart';
import 'package:flutter/material.dart';

class DefaultDayTileBuilder extends DayTileBuilder {

  DefaultDayTileBuilder();

  @override
  Widget build(BuildContext context, DateTime date) {
    return CalendarroDayItem(date: date, calendarroState: Calendarro.of(context));
  }
}