library calendarro;

import 'package:calendarro/calendarro_page.dart';
import 'package:calendarro/date_range.dart';
import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';

abstract class DayTileBuilder {
  Widget build(BuildContext context, DateTime date, DateTimeCallback onTap);
}

enum DisplayMode { MONTHS, WEEKS }
enum SelectionMode { SINGLE, MULTI, RANGE }

typedef void DateTimeCallback(DateTime datetime, bool isSelected);
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

  final DateTime selectedSingleDate;
  final List<DateTime> selectedDates;

  final int startDayOffset;
  final CalendarroState state;
  final double calendarSize;
  final Color backgroundColor;

  Calendarro({
    Key key,
    this.startDate,
    this.endDate,
    this.displayMode = DisplayMode.WEEKS,
    this.dayTileBuilder,
    this.selectedSingleDate,
    this.selectedDates,
    this.selectionMode = SelectionMode.SINGLE,
    this.onTap,
    this.onPageSelected,
    this.weekdayLabelsRow,
    this.startDayOffset,
    this.state,
    this.calendarSize,
    this.backgroundColor = Colors.black,
  });

  static CalendarroState of(BuildContext context) =>
      context.findAncestorStateOfType<CalendarroState>();

  @override
  CalendarroState createState() {
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
        date.difference(DateUtils.toMidnight(startDate)).inDays;
    int weekendsDifference = (daysDifference + startDate.weekday) ~/ 7;
    var position = daysDifference - weekendsDifference * 2;
    return position;
  }

  int getPageForDate(DateTime date) {
    if (displayMode == DisplayMode.WEEKS) {
      int daysDifferenceFromStartDate = date.difference(startDate).inDays;
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
  DateTime selectedSingleDate;
  List<DateTime> selectedDates;

  int pagesCount;
  PageView pageView;

  CalendarroState({this.selectedSingleDate, this.selectedDates});

  @override
  void initState() {
    super.initState();

    if (selectedSingleDate == null) {
      selectedSingleDate = widget.startDate;
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
              widget.startDate, widget.endDate) +
          1;
    }

    pageView = PageView.builder(
      itemBuilder: (context, position) => _buildCalendarPage(position),
      itemCount: pagesCount,
      controller: PageController(
          initialPage: selectedSingleDate != null
              ? widget.getPageForDate(selectedSingleDate)
              : 0),
      onPageChanged: (page) {
        if (widget.onPageSelected != null) {
          DateRange pageDateRange = _calculatePageDateRange(page);
          widget.onPageSelected(pageDateRange.startDate, pageDateRange.endDate);
        }
      },
    );

    double widgetHeight;
    if (widget.displayMode == DisplayMode.WEEKS) {
      widgetHeight = widget.calendarSize + widget.calendarSize;
    } else {
      var maxWeeksNumber = DateUtils.calculateMaxWeeksNumberMonthly(
          widget.startDate, widget.endDate);
      widgetHeight = widget.calendarSize + maxWeeksNumber * widget.calendarSize;
    }

    return Container(
      color: widget.backgroundColor,
      height: widgetHeight,
      child: pageView,
    );
  }

  // ignore: missing_return
  bool isDateSelected(DateTime date) {
    switch (widget.selectionMode) {
      case SelectionMode.SINGLE:
        return DateUtils.isSameDay(selectedSingleDate, date);
        break;
      case SelectionMode.MULTI:
        final matchedSelectedDate = selectedDates.firstWhere(
            (currentDate) => DateUtils.isSameDay(currentDate, date),
            orElse: () => null);

        return matchedSelectedDate != null;
        break;
      case SelectionMode.RANGE:
        switch (selectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(selectedDates[0], date);
          default:
            var dateBetweenDatesRange = (date.isAfter(selectedDates[0]) &&
                date.isBefore(selectedDates[1]));
            return DateUtils.isSameDay(date, selectedDates[0]) ||
                DateUtils.isSameDay(date, selectedDates[1]) ||
                dateBetweenDatesRange;
        }
        break;
    }
  }

  void toggleDateSelection(DateTime date) {
    setState(() {
      for (var i = selectedDates.length - 1; i >= 0; i--) {
        if (DateUtils.isSameDay(selectedDates[i], date)) {
          selectedDates.removeAt(i);
          return;
        }
      }

      selectedDates.add(date);
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
      weekdayLabelsRow: widget.weekdayLabelsRow,
      startDayOffset: pageDateRange.startDate.weekday - DateTime.monday,
    );
  }

  Widget _buildCalendarPageInMonthsMode(int position) {
    DateRange pageDateRange = _calculatePageDateRangeInMonthsMode(position);

    return CalendarroPage(
      pageStartDate: pageDateRange.startDate,
      pageEndDate: pageDateRange.endDate,
      weekdayLabelsRow: widget.weekdayLabelsRow,
      startDayOffset: pageDateRange.startDate.weekday - DateTime.monday,
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
      DateTime firstDateOfCurrentMonth =
          DateUtils.addMonths(widget.startDate, pagePosition);
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
    switch (selectedDates.length) {
      case 0:
        selectedDates.add(date);
        break;
      case 1:
        var firstDate = selectedDates[0];
        if (firstDate.isBefore(date)) {
          selectedDates.add(date);
        } else {
          selectedDates.clear();
          selectedDates.add(date);
          selectedDates.add(firstDate);
        }
        break;
      default:
        selectedDates.clear();
        selectedDates.add(date);
        break;
    }
  }

  void _setMultiSelectedDate(DateTime date) {
    final alreadyExistingDate = selectedDates.firstWhere(
        (currentDate) => DateUtils.isSameDay(currentDate, date),
        orElse: () => null);

    if (alreadyExistingDate != null) {
      selectedDates.remove(alreadyExistingDate);
    } else {
      selectedDates.add(date);
    }
  }
}
