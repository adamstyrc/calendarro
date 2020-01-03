import 'package:flutter/widgets.dart';

class CalendarroWeekdayLabelsView extends StatelessWidget {
  final DateTime monday = DateTime(2020, 01, 06);
  final DateTime tuesday = DateTime(2020, 01, 07);
  final DateTime wednesday = DateTime(2020, 01, 08);
  final DateTime thursday = DateTime(2020, 01, 09);
  final DateTime friday = DateTime(2020, 01, 10);
  final DateTime saturday = DateTime(2020, 01, 11);
  final DateTime sunday = DateTime(2020, 01, 12);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            DateFormat('E').format(monday),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            DateFormat('E').format(tuesday),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            DateFormat('E').format(wednesday),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            DateFormat('E').format(thursday),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            DateFormat('E').format(friday),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            DateFormat('E').format(saturday),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Text(
            DateFormat('E').format(sunday),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
