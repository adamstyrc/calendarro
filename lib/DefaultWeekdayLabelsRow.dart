import 'package:flutter/widgets.dart';

class CalendarroWeekdayLabelsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("Mon", textAlign: TextAlign.center)),
        Expanded(child: Text("Tue", textAlign: TextAlign.center)),
        Expanded(child: Text("Wed", textAlign: TextAlign.center)),
        Expanded(child: Text("Thu", textAlign: TextAlign.center)),
        Expanded(child: Text("Fri", textAlign: TextAlign.center)),
        Expanded(child: Text("Sat", textAlign: TextAlign.center)),
        Expanded(child: Text("Sun", textAlign: TextAlign.center)),
      ],
    );
  }
}