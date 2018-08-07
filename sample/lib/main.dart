import 'package:calendarro/DateUtils.dart';
import 'package:flutter/material.dart';
import 'package:calendarro/Calendarro.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Calendarro Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: Column(
          children: <Widget>[
            Container(
              color: Colors.lightGreen,
//              height: 100.0,
              child: Calendarro(
                displayMode: DisplayMode.WEEKS,
                startDate: DateUtils.getFirstDayOfCurrentMonth(),
                endDate: DateUtils.getLastDayOfCurrentMonth(),
              ),
            ),
            Container(height: 32.0),
            Calendarro(
              startDate: DateUtils.getFirstDayOfCurrentMonth(),
              endDate: DateUtils.getLastDayOfNextMonth(),
              displayMode: DisplayMode.MONTHS,
              selectionMode: SelectionMode.MULTI,
            )
          ],
        ),
    );
  }
}

