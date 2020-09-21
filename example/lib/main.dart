import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:calendarro/calendarro.dart';
import 'package:intl/intl.dart';

List months = ["January","February","March","April","May","June","July","August","September","October","November","December"];

var now = new DateTime.now();

void main() => runApp(new MyApp());


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
  Calendarro monthCalendarro;
  @override
  Widget build(BuildContext context) {

    print("Current month: $currentMonth");
    monthCalendarro = Calendarro(
      startDate: startDate,
      endDate: endDate,
      displayMode: DisplayMode.MONTHS,
      selectionMode: SelectionMode.MULTI,
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
        monthCalendarro
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
