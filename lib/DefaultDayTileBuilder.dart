import 'package:calendarro/Calendarro.dart';
import 'package:calendarro/DefaultDayTile.dart';
import 'package:flutter/material.dart';

class DefaultDayTileBuilder extends DayTileBuilder {

  DefaultDayTileBuilder();

  @override
  Widget build(BuildContext context, DateTime date) {
    return CalendarroDayItem(date: date, calendarroState: Calendarro.of(context));
  }
}