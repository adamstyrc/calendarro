import 'package:calendarro/calendarro.dart';
import 'package:calendarro/default_day_tile.dart';
import 'package:flutter/material.dart';

class DefaultDayTileBuilder extends DayTileBuilder {

  DefaultDayTileBuilder();

  @override
  Widget build(BuildContext context, DateTime date, DateTimeCallback? onTap) {
    final state = Calendarro.of(context);
    if (state == null) {
      throw StateError('calendarroState is null');
    }

    return CalendarroDayItem(date: date, calendarroState: state, onTap: onTap);
  }
}