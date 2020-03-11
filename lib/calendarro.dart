library calendarro;

import 'package:calendarro/calendarro_page.dart';
import 'package:calendarro/date_range.dart';
import 'package:calendarro/default_weekday_labels_row.dart';
import 'package:calendarro/date_utils.dart';
import 'package:calendarro/default_day_tile_builder.dart';
import 'package:flutter/material.dart';
import 'default_header_builder.dart';

abstract class DayTileBuilder {
  Widget build(BuildContext context, DateTime date, DateTimeCallback onTap);
}

abstract class HeaderBuilder {
  Widget build(BuildContext context, String title, int curPage);
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
  final HeaderBuilder headerBuilder;
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
    headerBuilder,
    this.selectedSingleDate,
    selectedDates,
    this.selectionMode = SelectionMode.SINGLE,
    this.onTap,
    this.onPageSelected,
    this.onSelectChange,
    weekdayLabelsRow,
  }) : this.startDate = DateUtils.toMidnight(startDate ?? DateUtils.getFirstDayOfCurrentMonth()),
      this.endDate = DateUtils.toMidnight(endDate ?? DateUtils.getLastDayOfNextMonth()),
      this.weekdayLabelsRow = weekdayLabelsRow ?? CalendarroWeekdayLabelsView(),
      this.headerBuilder = headerBuilder ?? DefaultHeaderBuilder(),
      this.dayTileBuilder = dayTileBuilder ?? DefaultDayTileBuilder(),
      this.selectedDates = selectedDates ?? [],
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
        selectedDates: selectedDates);
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
  final double headerHeight = 40.0;

  DateTime selectedSingleDate;
  List<DateTime> selectedDates;

  int pagesCount;
  PageView pageView;
  int curPage;

  CalendarroState({
    this.selectedSingleDate,
    this.selectedDates,
  });

  void initState() {
    super.initState();
    curPage = widget.getPageForDate(selectedSingleDate);
  }

  DateTime existItems(DateTime date){
    return selectedDates.firstWhere((currentDate) =>
      DateUtils.isSameDay(currentDate, date),
      orElse: () => null
    );
  }
  bool listAdd(DateTime date) {
    selectedDates.add(date);
    selectedDates.sort((a, b) => a.compareTo(b));
    widget.onSelectChange?.call(selectedDates);
    return true;
  }
  void listToggle(DateTime date){
    for (var i = selectedDates.length - 1; i >= 0; i--) {
      if (DateUtils.isSameDay(selectedDates[i], date)) {
        selectedDates.removeAt(i);
        widget.onSelectChange?.call(selectedDates);
        return;
      }
    }
    listAdd(date);
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
    int page = widget.getPageForDate(date);
    movePage(page);
  }

  void movePage(int page) {
    pageView.controller.jumpToPage(page);
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
        setState(() {
          curPage = page;
        });
        DateRange curPageDataRange = _calculatePageDateRange(page);
        widget.onPageSelected
            ?.call(curPageDataRange.startDate, curPageDataRange.endDate);
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
          + maxWeeksNumber * dayTileHeight + headerHeight;
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
        return existItems(date) != null;
        break;
      case SelectionMode.RANGE:
        switch (selectedDates.length) {
          case 0:
            return false;
          case 1:
            return DateUtils.isSameDay(selectedDates[0], date);
          default:
            var dateBetweenDatesRange = (date.isAfter(selectedDates[0])
                && date.isBefore(selectedDates[1]));
            return DateUtils.isSameDay(date, selectedDates[0])
              || DateUtils.isSameDay(date, selectedDates[1])
              || dateBetweenDatesRange;
        }
        break;
      default:
        throw ArgumentError("Calendarro: ${widget.selectionMode} is is Not supported selectionMode");
    }
  }

  void toggleDateSelection(DateTime date) {
    setState(() {
      listToggle(date);
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
      curPage: curPage,
    );
  }

  Widget _buildCalendarPageInMonthsMode(int position) {
    DateRange pageDateRange = _calculatePageDateRangeInMonthsMode(position);

    return CalendarroPage(
      pageStartDate: pageDateRange.startDate,
      pageEndDate: pageDateRange.endDate,
      weekdayLabelsRow: widget.weekdayLabelsRow,
      curPage: curPage,
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
    switch (selectedDates.length) {
      case 0:
        listAdd(date);
        break;
      case 1:
        if(existItems(date) != null) break;
        listAdd(date);
        break;
      default:
        selectedDates.clear();
        listAdd(date);
        break;
    }
  }

  void _setMultiSelectedDate(DateTime datetime) {
    listToggle(datetime);
  }
}
