library calendarro;

import 'package:calendarro/calendarro_page.dart';
import 'package:calendarro/date_range.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:calendarro/date_utils.dart';
import 'package:calendarro/default_day_tile_builder.dart';
import 'package:flutter/material.dart';

abstract class DayTileBuilder {
  Widget build(BuildContext context, DateTime date, DateTimeCallback onTap);
}

enum DisplayMode { MONTHS, WEEKS }
enum SelectionMode { SINGLE, MULTI, RANGE }

typedef void DateTimeCallback(DateTime datetime);
typedef void CurrentPageCallback(DateTime pageStartDate, DateTime pageEndDate);

class Calendarro extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final DisplayMode displayMode;
  final SelectionMode selectionMode;
  final DayTileBuilder dayTileBuilder;
  final Widget weekdayLabelsRow;
  final DateTimeCallback onTap;
  final CurrentPageCallback onPageSelected;
  final ValueChanged<List<DateTime>> onSelectChange;

  final DateTime selectedSingleDate;
  final List<DateTime> selectedDates;

  int startDayOffset;
  CalendarroState state;

  Calendarro({
    Key key,
    startDate,
    endDate,
    this.displayMode = DisplayMode.WEEKS,
    dayTileBuilder,
    this.selectedSingleDate,
    this.selectedDates,
    this.selectionMode = SelectionMode.SINGLE,
    this.onTap,
    this.onPageSelected,
    this.onSelectChange,
    weekdayLabelsRow,
  }) : this.startDate = DateUtils.toMidnight(startDate ?? DateUtils.getFirstDayOfCurrentMonth()),
      this.endDate = DateUtils.toMidnight(endDate ?? DateUtils.getLastDayOfNextMonth()),
      this.weekdayLabelsRow = weekdayLabelsRow ?? CalendarroWeekdayLabelsView(),
      this.dayTileBuilder = dayTileBuilder ?? DefaultDayTileBuilder(),
      super(key: key) {
    if (this.startDate.isAfter(this.endDate)) {
      throw ArgumentError("Calendarro: startDate is after the endDate");
    }
    startDayOffset = this.startDate.weekday - DateTime.monday;
  }

  static CalendarroState of(BuildContext context) =>
      context.findAncestorStateOfType<CalendarroState>();

  @override
  CalendarroState createState() {
    state = CalendarroState(
        selectedSingleDate: selectedSingleDate ?? startDate,
        selectedDates: selectedDates ?? []);
    return state;
  }

  void setSelectedDate(DateTime date) {
    state.setSelectedDate(date);
  }

  void toggleDate(DateTime date) {
    state.toggleDateSelection(date);
  }

  void setCurrentDate(DateTime date) {
    state.setCurrentDate(date);
  }

  int getPositionOfDate(DateTime date) {
    int daysDifference =
        date
            .difference(DateUtils.toMidnight(startDate))
            .inDays;
    int weekendsDifference = (daysDifference + startDate.weekday) ~/ 7;
    var position = daysDifference - weekendsDifference * 2;
    return position;
  }

  int getPageForDate(DateTime date) {
    date = DateUtils.toMidnight(date);
    if (displayMode == DisplayMode.WEEKS) {
      int daysDifferenceFromStartDate = date
          .difference(startDate)
          .inDays;
      int page = (daysDifferenceFromStartDate + startDayOffset) ~/ 7;
      return page;
    } else {
      var monthDifference = (date.year * 12 + date.month) -
          (startDate.year * 12 + startDate.month);
      return monthDifference;
    }
  }
}

class CalendarroState extends State<Calendarro> {
  final double dayTileHeight = 40.0;
  final double dayLabelHeight = 20.0;

  DateTime _selectedSingleDate;
  set selectedSingleDate(DateTime dateTime) {
    final date = DateUtils.toMidnight(dateTime);
    _selectedSingleDate = date;
    widget.onTap?.call(_selectedSingleDate);
  }
  DateTime get selectedSingleDate {
    return _selectedSingleDate;
  }
  final List<DateTime> _selectedDates;
  int pagesCount;
  PageView pageView;

  CalendarroState({
    selectedSingleDate,
    List<DateTime> selectedDates,
  }): this._selectedDates = selectedDates.map((e) => DateUtils.toMidnight(e)).toList(),
      this._selectedSingleDate = selectedSingleDate;

  bool listContains(DateTime dateTime){
    final date = DateUtils.toMidnight(dateTime);
    return _selectedDates.contains(date);
  }
  bool listAdd(DateTime dateTime) {
    final date = DateUtils.toMidnight(dateTime);
    if(_selectedDates.contains(date)) return false;
    _selectedDates.add(date);
    _selectedDates.sort((a, b) => a.isBefore(b) ? -1 : 1);
    widget.onSelectChange?.call(_selectedDates);
    return true;
  }
  bool listRemove(DateTime dateTime){
    final date = DateUtils.toMidnight(dateTime);
    bool res = _selectedDates.remove(date);
    widget.onSelectChange?.call(_selectedDates);
    return res;
  }
  void listToggle(DateTime dateTime){
    if(listContains(dateTime)) {
      listRemove(dateTime);
    } else {
      listAdd(dateTime);
    }
  }

  void setSelectedDate(DateTime date) {
    setState(() {
      switch (widget.selectionMode) {
        case SelectionMode.SINGLE:
          selectedSingleDate = date;
          break;
        case SelectionMode.MULTI:
          _setMultiSelectedDate(date);
          break;
        case SelectionMode.RANGE:
          _setRangeSelectedDate(date);
          break;
      }
    });
  }

  void setCurrentDate(DateTime date) {
    setState(() {
      int page = widget.getPageForDate(date);
      pageView.controller.jumpToPage(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.displayMode == DisplayMode.WEEKS) {
      int lastPage = widget.getPageForDate(widget.endDate);
      pagesCount = lastPage + 1;
    } else {
      pagesCount = DateUtils.calculateMonthsDifference(
          widget.startDate,
          widget.endDate) + 1;
    }

    pageView = PageView.builder(
      itemBuilder: (context, position) => _buildCalendarPage(position),
      itemCount: pagesCount,
      controller: PageController(
          initialPage:
          widget.getPageForDate(selectedSingleDate) ?? 0),
      onPageChanged: (page) {
        DateRange pageDateRange = _calculatePageDateRange(page);
        widget.onPageSelected?.call(pageDateRange.startDate, pageDateRange.endDate);
      },
    );

    double widgetHeight;
    if (widget.displayMode == DisplayMode.WEEKS) {
      widgetHeight = dayLabelHeight + dayTileHeight;
    } else {
      var maxWeeksNumber = DateUtils.calculateMaxWeeksNumberMonthly(
          widget.startDate,
          widget.endDate);
      widgetHeight = dayLabelHeight
          + maxWeeksNumber * dayTileHeight;
    }

    return Container(
        height: widgetHeight,
        child: pageView);
  }

  bool isDateSelected(DateTime date) {
    switch (widget.selectionMode) {
      case SelectionMode.SINGLE:
        return DateUtils.isSameDay(selectedSingleDate, date);
        break;
      case SelectionMode.MULTI:
        return _selectedDates.contains(date);
        break;
      case SelectionMode.RANGE:
        switch (_selectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(_selectedDates[0], date);
          default:
            var dateBetweenDatesRange = (date.isAfter(_selectedDates[0])
                && date.isBefore(_selectedDates[1]));
            return DateUtils.isSameDay(date, _selectedDates[0])
              || DateUtils.isSameDay(date, _selectedDates[1])
              || dateBetweenDatesRange;
        }
        break;
      default:
        throw ArgumentError("Calendarro: ${widget.selectionMode} is is Not supported selectionMode");
    }
  }

  void toggleDateSelection(DateTime datetime) {
    setState(() {
      listToggle(datetime);
    });
  }

  void update() {
    setState(() {});
  }

  Widget _buildCalendarPage(int position) {
    if (widget.displayMode == DisplayMode.WEEKS) {
      return _buildCalendarPageInWeeksMode(position);
    } else {
      return _buildCalendarPageInMonthsMode(position);
    }
  }

  Widget _buildCalendarPageInWeeksMode(int position) {
    DateRange pageDateRange = _calculatePageDateRange(position);

    return CalendarroPage(
        pageStartDate: pageDateRange.startDate,
        pageEndDate: pageDateRange.endDate,
        weekdayLabelsRow: widget.weekdayLabelsRow);
  }

  Widget _buildCalendarPageInMonthsMode(int position) {
    DateRange pageDateRange = _calculatePageDateRangeInMonthsMode(position);

    return CalendarroPage(
      pageStartDate: pageDateRange.startDate,
      pageEndDate: pageDateRange.endDate,
      weekdayLabelsRow: widget.weekdayLabelsRow,
    );
  }

  DateRange _calculatePageDateRange(int pagePosition) {
    if (widget.displayMode == DisplayMode.WEEKS) {
      return _calculatePageDateRangeInWeeksMode(pagePosition);
    } else {
      return _calculatePageDateRangeInMonthsMode(pagePosition);
    }
  }

  DateRange _calculatePageDateRangeInMonthsMode(int pagePosition) {
    DateTime pageStartDate;
    DateTime pageEndDate;

    if (pagePosition == 0) {
      pageStartDate = widget.startDate;
      if (pagesCount <= 1) {
        pageEndDate = widget.endDate;
      } else {
        var lastDayOfMonth = DateUtils.getLastDayOfMonth(widget.startDate);
        pageEndDate = lastDayOfMonth;
      }
    } else if (pagePosition == pagesCount - 1) {
      pageStartDate = DateUtils.getFirstDayOfMonth(widget.endDate);
      pageEndDate = widget.endDate;
    } else {
      DateTime firstDateOfCurrentMonth = DateUtils.addMonths(
          widget.startDate,
          pagePosition);
      pageStartDate = firstDateOfCurrentMonth;
      pageEndDate = DateUtils.getLastDayOfMonth(firstDateOfCurrentMonth);
    }

    return DateRange(pageStartDate, pageEndDate);
  }

  DateRange _calculatePageDateRangeInWeeksMode(int pagePosition) {
    DateTime pageStartDate;
    DateTime pageEndDate;

    if (pagePosition == 0) {
      pageStartDate = widget.startDate;
      pageEndDate =
          DateUtils.addDaysToDate(widget.startDate, 6 - widget.startDayOffset);
    } else if (pagePosition == pagesCount - 1) {
      pageStartDate = DateUtils.addDaysToDate(
          widget.startDate, 7 * pagePosition - widget.startDayOffset);
      pageEndDate = widget.endDate;
    } else {
      pageStartDate = DateUtils.addDaysToDate(
          widget.startDate, 7 * pagePosition - widget.startDayOffset);
      pageEndDate = DateUtils.addDaysToDate(
          widget.startDate, 7 * pagePosition + 6 - widget.startDayOffset);
    }

    return DateRange(pageStartDate, pageEndDate);
  }

  void _setRangeSelectedDate(DateTime date) {
    switch (_selectedDates.length) {
      case 0:
        listAdd(date);
        break;
      case 1:
        listAdd(date);
        break;
      default:
        _selectedDates.clear();
        listAdd(date);
        break;
    }
  }

  void _setMultiSelectedDate(DateTime datetime) {
    listToggle(datetime);
  }
}
