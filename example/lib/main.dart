import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:calendarro/calendarro.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Calendarro Demo',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new MyHomePage(title: 'Calendarro Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var lastDayOfNextMonth = DateUtils.getLastDayOfNextMonth();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.orange,
            child: Calendarro(),
          ),
          Container(height: 32.0),
          Calendarro(
//            startDate: DateUtils.getFirstDayOfCurrentMonth(),
            startDate: DateUtils.getFirstDayOfNextMonth(),
            endDate: lastDayOfNextMonth,
//            endDate: DateUtils.getLastDayOfNextMonth(),
            displayMode: DisplayMode.MONTHS,
            selectionMode: SelectionMode.MULTI,
            weekdayLabelsRow: CustomWeekdayLabelsRow(),
          )
        ],
      ),
    );
  }
}


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
