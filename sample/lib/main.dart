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
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Calendarro(
              startDate: DateUtils.getFirstDayOfCurrentMonth(),
              endDate: DateUtils.getLastDayOfNextMonth(),
              displayMode: DisplayMode.MONTHS,
              selectionMode: SelectionMode.SINGLE,
            )
          ],
        ),
      )
    );
  }
}

