import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:calendarro/default_day_tile_builder.dart';
import 'package:flutter/material.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendarro Demo',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Calendarro Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  Calendarro monthCalendarro;

  final DateTime startDate = DateUtils.getFirstDayOfCurrentMonth();
  final DateTime endDate = DateUtils.getLastDayOfNextMonth();

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ResponsiveWidgets.init(
      context,
      height: 1920,
      width: 1080,
      allowFontScaling: false,
    );
    monthCalendarro = Calendarro(
      backgroundColor: Colors.black,
      startDayOffset: startDate.weekday - DateTime.monday,
      startDate: startDate,
      endDate: endDate,
      calendarSize: 100.h,
      displayMode: DisplayMode.MONTHS,
      selectionMode: SelectionMode.MULTI,
      state: CalendarroState(
        selectedSingleDate: DateTime.now(),
        selectedDates: List(),
      ),
      dayTileBuilder: DefaultDayTileBuilder(),
      weekdayLabelsRow: _CustomWeekdayLabelsRow(),
      onTap: (date, isSelected) {
        print("onTap: $date");
        print("isSelected: $isSelected");
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.orange,
            child: Calendarro(
              backgroundColor: Colors.black,
              startDayOffset: startDate.weekday - DateTime.monday,
              startDate: startDate,
              endDate: endDate,
              calendarSize: 100.h,
              displayMode: DisplayMode.WEEKS,
              selectionMode: SelectionMode.SINGLE,
              state: CalendarroState(
                selectedSingleDate: DateTime.now(),
                selectedDates: List(),
              ),
              dayTileBuilder: DefaultDayTileBuilder(),
              weekdayLabelsRow: _CustomWeekdayLabelsRow(),
              onTap: (date, isSelected) {
                print("onTap: $date");
                print("isSelected: $isSelected");
              },
            ),
          ),
          Container(height: 32.0),
          monthCalendarro
        ],
      ),
    );
  }
}

class _CustomWeekdayLabelsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsResponsive.symmetric(
        vertical: 30.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextResponsive(
              'M',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: TextResponsive(
              'T',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: TextResponsive(
              'W',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: TextResponsive(
              'T',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: TextResponsive(
              'F',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: TextResponsive(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: TextResponsive(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
