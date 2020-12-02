import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:calendarro/calendarro.dart';

import 'package:calendarro/date_utils.dart';
import 'package:intl/intl.dart';

List months = ["January","February","March","April","May","June","July","August","September","October","November","December"];

var now = new DateTime.now();

void main() => runApp(new MyApp());

class CustomDayTileBuilder extends DayTileBuilder{

  CustomDayTileBuilder();

  @override
  Widget build(BuildContext context, DateTime date, onTap) {
    return CustomCalenderDayItem(date: date, calendarroState: Calendarro.of(context), onTap: onTap,);
  }

}

class CustomCalenderDayItem extends StatelessWidget {
  CustomCalenderDayItem({this.date, this.calendarroState, this.onTap});

  DateTime date;
  CalendarroState calendarroState;
  DateTimeCallback onTap;

  @override
  Widget build(BuildContext context) {
    bool isWeekend = DateUtils.isWeekend(date);
    var textColor = isWeekend ? Colors.grey : Colors.black;
    bool isToday = DateUtils.isToday(date);
    calendarroState = Calendarro.of(context);

    bool daySelected = calendarroState.isDateSelected(date);

    BoxDecoration boxDecoration;
    if (daySelected) {
      boxDecoration = BoxDecoration(color: Colors.blue, shape: BoxShape.circle);
    } else if (isToday) {
      boxDecoration = BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          shape: BoxShape.circle);
    }

    return Expanded(
        child: GestureDetector(
          child: Column(
            children: [
              Container(
                  height: 20.0,
                  decoration: boxDecoration,
                  child: Center(
                      child: Text(
                        "${date.day}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: textColor),
                      ))),
              Container(
                height: 20.0,
                child: Image.network("https://www.netclipart.com/pp/m/138-1388728_cloudy-day-outlined-cloudy-weather-icon-png.png"),
              )
            ],
          ),
          onTap: handleTap,
          behavior: HitTestBehavior.translucent,
        ));
  }
  void handleTap() {
    if (onTap != null) {
      onTap(date);
    }

    calendarroState.setSelectedDate(date);
    calendarroState.setCurrentDate(date);
  }
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Demo",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Demo"),
        ),
        body: Container(
          height: 3000,
          child: Calender(),
        ),
      ),
    );
  }
}

class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  var currentMonth = now.month;
  var startDate = DateUtils.getFirstDayOfCurrentMonth();
  var endDate = DateTime(2021);
  List<DateTime> selectedDates = [];
  DateTime singleSelectedDate;
  Calendarro monthCalendarro;
  @override
  Widget build(BuildContext context) {

    print("Current month: $currentMonth");
    print("Selected Dates : $selectedDates");
    monthCalendarro = Calendarro(
      dayTileBuilder: CustomDayTileBuilder(),
      startDate: startDate,
      endDate: endDate,
      displayMode: DisplayMode.MONTHS,
      selectionMode: SelectionMode.SINGLE,
      selectedDates: selectedDates,
      selectedSingleDate: singleSelectedDate,
      weekdayLabelsRow: CustomWeekdayLabelsRow(),
      onPageSelected: (nextStartDate, nextEndDate){
        print("Selected $nextStartDate - $nextEndDate");
        setState(() {
          currentMonth = nextStartDate.month;
          //startDate = nextStartDate;
          //endDate = nextEndDate;
        });
        print(currentMonth);
      },
      onTap: (date){
        print("Tapped $date");
        setState(() {
          //selectedDates = selectedDates;
        });
      },
    );
    return Column(
      children: [
        Container(
          color: Colors.red,
          child: Text(
            months[currentMonth-1],
            textAlign: TextAlign.center,
          ),
        ),
        monthCalendarro,
        Container(
          child: Text("$selectedDates"),
        ),
      ],
    );
  }
}




//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      title: 'Calendarro Demo',
//      theme: new ThemeData(
//        primarySwatch: Colors.orange,
//      ),
//      home: new MyHomePage(title: 'Calender Demo'),
//    );
//  }
//}
//
//class MyHomePage extends StatelessWidget {
//  final String title;
//  var currentMonth = 0;
//  Calendarro monthCalendarro;
//
//  MyHomePage({Key key, this.title}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    var startDate = DateUtils.getFirstDayOfCurrentMonth();
//    var endDate = DateUtils.getLastDayOfNextMonth();
//    var now = new DateTime.now();
//    currentMonth = now.month;
//    monthCalendarro = Calendarro(
//        startDate: startDate,
//        endDate: endDate,
//        displayMode: DisplayMode.MONTHS,
//        selectionMode: SelectionMode.MULTI,
//        weekdayLabelsRow: CustomWeekdayLabelsRow(),
//        onPageSelected: (startDate,endDate){
//          print("Selected $startDate : $endDate");
//          currentMonth =startDate.month;
//          print(currentMonth);
//        },
//        onTap: (date) {
//          print("onTap: $date");
//        });
//
//    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text(title),
//      ),
//      body: Column(
//        children: <Widget>[
//          Container(
//            color: Colors.red,
//              child: Text(
//                months[currentMonth+1],
//                textAlign: TextAlign.center,
//              ),
//              height: 32.0),
//          monthCalendarro
//        ],
//      ),
//    );
//  }
//}

class CustomWeekdayLabelsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("M", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("W", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("F", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
      ],
    );
  }
}
